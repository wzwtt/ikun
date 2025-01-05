<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    pics: Array
});
const surl = __SOURCE_IMGURL__;

// Current number of displayed images
const currentCount = ref(12);
// Number of images to load each time
const batchSize = ref(8);
// Loading state
const isLoading = ref(false);

// Compute current displayed images
const displayedPics = computed(() => {
    return props.pics?.slice(0, currentCount.value) || [];
});

// Check scroll position and load more images
const checkScroll = async () => {
    if (isLoading.value) return;
    
    const scrollPosition = window.scrollY + window.innerHeight;
    const documentHeight = document.documentElement.scrollHeight;
    
    // Load more when scrolled to 100px from bottom
    if (documentHeight - scrollPosition < 100 && currentCount.value < props.pics?.length) {
        isLoading.value = true;
        // Simulate loading delay
        await new Promise(resolve => setTimeout(resolve, 300));
        currentCount.value += batchSize.value;
        isLoading.value = false;
    }
};

// Initialize display count based on viewport size
const initializeDisplayCount = () => {
    const viewportHeight = window.innerHeight;
    const viewportWidth = window.innerWidth;
    // Calculate how many images can fit in a row
    const picsPerRow = Math.floor(viewportWidth * 0.9 / 330);
    // Calculate how many rows can fit
    const rows = Math.ceil(viewportHeight / 187) + 1;
    currentCount.value = picsPerRow * rows;
};

onMounted(() => {
    initializeDisplayCount();
    window.addEventListener('scroll', checkScroll);
    window.addEventListener('resize', initializeDisplayCount);
});

onUnmounted(() => {
    window.removeEventListener('scroll', checkScroll);
    window.removeEventListener('resize', initializeDisplayCount);
});
</script>

<template>
    <div class="pics_container">
        <div v-for="pic in displayedPics" :key="pic" class="pic">
            <img :src="surl + pic" :alt="pic">
        </div>
        <div v-if="isLoading" class="loading">
            <img src="/favicon.ico" class="loading-icon" alt="loading">
            <span>加载中...</span>
        </div>
    </div>
</template>

<style scoped>
.pics_container {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    margin-left: 5%;
    margin-right: 5%;
    gap: 10px;
}

.pic {
    height: 187px;
    width: 330px;
    overflow: hidden;
    background-color: var(--card-bg);
    box-shadow: 0 2px 8px var(--card-shadow);
    transition: background-color 0.3s, box-shadow 0.3s;
}

.pic img {
    width: auto;
    height: 100%;
    object-fit: cover;
    display: block;
    border-radius: 4px;
    margin: auto;
}

.loading {
    width: 100%;
    text-align: center;
    padding: 20px;
    color: var(--text-color);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.loading-icon {
    width: 20px;
    height: 20px;
    animation: bounce 0.6s infinite alternate;
}

@keyframes bounce {
    from {
        transform: translateY(0);
    }
    to {
        transform: translateY(-6px);
    }
}
</style>