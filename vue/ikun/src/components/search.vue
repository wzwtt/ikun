<script setup>
import { ref, onMounted, onUnmounted } from 'vue';

const props = defineProps({
  onSearch: {
    type: Function,
    required: true
  }
});

const searchText = ref('');
const isFloating = ref(false);
const isFloatingExpanded = ref(false);

// Handle input changes
const handleInput = (e) => {
  searchText.value = e.target.value;
  props.onSearch(searchText.value);
};

// Clear search input
const clearSearch = () => {
  searchText.value = '';
  props.onSearch('');
};

// Toggle floating search box expansion state
const toggleFloatingSearch = () => {
  if (isFloating.value) {
    isFloatingExpanded.value = !isFloatingExpanded.value;
    if (isFloatingExpanded.value) {
      // Auto focus input when expanded
      setTimeout(() => {
        document.querySelector('.floating-input')?.focus();
      }, 100);
    }
  }
};

// Scroll event handler with debounce
let scrollTimeout;
const handleScroll = () => {
  if (scrollTimeout) {
    clearTimeout(scrollTimeout);
  }
  
  scrollTimeout = setTimeout(() => {
    const scrollTop = window.scrollY || document.documentElement.scrollTop;
    if (scrollTop > 100) {
      if (!isFloating.value) {
        isFloating.value = true;
        // Keep collapsed when switching to floating state
        isFloatingExpanded.value = false;
      }
    } else {
      isFloating.value = false;
      isFloatingExpanded.value = false;
      // Auto focus top search box when switching back
      setTimeout(() => {
        if (searchText.value) {
          document.querySelector('.fixed-search .search-input')?.focus();
        }
      }, 100);
    }
  }, 10);
};

onMounted(() => {
  window.addEventListener('scroll', handleScroll);
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
});
</script>

<template>
  <!-- Fixed top search box -->
  <div class="search-container fixed-search" :class="{ 'fixed-search-hidden': isFloating }">
    <div class="search-box">
      <div class="search-content">
        <i class="search-icon" aria-hidden="true">🔍</i>
        <input 
          type="text" 
          v-model="searchText"
          @input="handleInput"
          placeholder="搜索表情包..."
          class="search-input"
          aria-label="搜索表情包"
        >
        <button 
          v-if="searchText" 
          @click="clearSearch" 
          class="clear-button"
          aria-label="清除搜索内容"
        >
          <span aria-hidden="true">✕</span>
        </button>
      </div>
    </div>
  </div>

  <!-- Floating search box -->
  <div class="search-container floating-search" :class="{
    'floating-search-visible': isFloating,
    'floating-search-expanded': isFloatingExpanded
  }">
    <div class="search-box">
      <div class="search-content" :class="{ 'search-content-expanded': isFloatingExpanded }">
        <button 
          class="search-toggle"
          @click="toggleFloatingSearch"
          :aria-expanded="isFloatingExpanded"
          :aria-label="isFloatingExpanded ? '收起搜索框' : '展开搜索框'"
          :title="isFloatingExpanded ? '收起搜索框' : '展开搜索框'"
        >
          <i class="search-icon" aria-hidden="true">🔍</i>
        </button>
        
        <input 
          v-show="isFloatingExpanded"
          type="text" 
          v-model="searchText"
          @input="handleInput"
          placeholder="搜索表情包..."
          class="search-input floating-input"
          aria-label="搜索表情包"
        >
        <button 
          v-if="searchText && isFloatingExpanded" 
          @click="clearSearch" 
          class="clear-button"
          aria-label="清除搜索内容"
        >
          <span aria-hidden="true">✕</span>
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.search-container {
  width: 100%;
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.search-box {
  position: relative;
  max-width: 500px;
  display: flex;
  justify-content: center;
}

/* Fixed search box width */
.fixed-search .search-box {
  width: 90%;
}

.search-content {
  position: relative;
  display: flex;
  align-items: center;
  width: 100%;
  max-width: 500px;
  height: 48px;
  background: var(--card-bg);
  border-radius: 24px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.15);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  overflow: hidden;
}

/* Fixed search box styles */
.fixed-search {
  position: relative;
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}

.fixed-search-hidden {
  opacity: 0;
  transform: translateY(-20px);
  pointer-events: none;
}

/* Floating search box styles */
.floating-search {
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: auto;
  margin: 0;
  z-index: 1000;
  opacity: 0;
  pointer-events: none;
}

.floating-search .search-box {
  width: auto;
}

.floating-search .search-content {
  width: 48px;
  height: 48px;
  margin-left: auto;
  background-color: var(--card-bg);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.floating-search-visible {
  opacity: 1;
  pointer-events: auto;
}

.search-content-expanded {
  width: 300px !important;
  background-color: var(--card-bg) !important;
}

.search-input {
  flex: 1;
  height: 100%;
  padding: 0 40px 0 45px;
  border: none;
  background: var(--card-bg);
  color: var(--text-color);
  font-size: 16px;
  outline: none;
}

/* Input styles in floating state */
.floating-search .search-input {
  padding: 0;
}

.search-icon {
  position: absolute;
  left: 12px;
  color: var(--text-color);
  font-size: 18px;
  z-index: 1;
  transition: color 0.3s ease;
}

.search-toggle {
  width: 48px;
  height: 48px;
  padding: 0;
  border: none;
  background: var(--card-bg);
  border-radius: 50%;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.search-toggle:hover {
  box-shadow: 0 6px 20px rgba(0,0,0,0.35);
  transform: translateY(-1px);
}

.search-content-expanded .search-toggle {
  width: 48px;
  height: 48px;
  background: transparent;
  margin-right: -8px;
  box-shadow: none;
}

.search-content-expanded .search-toggle .search-icon {
  color: #666;
}

.search-content:focus-within {
  box-shadow: 0 0 0 3px #007bff40;
}

.search-toggle:focus-visible,
.search-input:focus-visible,
.clear-button:focus-visible {
  outline: none;
}

.floating-search .search-toggle .search-icon {
  position: static;
  color: #666;
}

.clear-button {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: var(--text-color);
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  transition: background-color 0.3s;
}

.clear-button:hover {
  background-color: rgba(0, 0, 0, 0.1);
}

/* Accessibility focus styles */
.search-toggle:focus-visible,
.search-input:focus-visible,
.clear-button:focus-visible {
  outline: none;
}

/* Mobile device adaptation */
@media (max-width: 768px) {
  .search-content-expanded {
    width: calc(100vw - 40px) !important;
    position: fixed;
    right: 20px;
    bottom: 20px;
    max-width: none;
  }

  .fixed-search .search-box {
    width: calc(100% - 20px);
  }
  
  .search-content {
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  }
}

/* Reduce motion */
@media (prefers-reduced-motion: reduce) {
  .search-container,
  .search-content,
  .search-toggle,
  .clear-button {
    transition: none;
  }
}

/* Animation transition optimization */
.floating-search-visible .search-content {
  transform: scale(1);
  opacity: 1;
}

.floating-search .search-content {
  transform: scale(0.95);
  opacity: 0.9;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
</style>