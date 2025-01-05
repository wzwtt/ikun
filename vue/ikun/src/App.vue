<script setup>

import pics from './components/pics.vue';
import search from './components/search.vue';
import detail from './components/detail.vue';

import { ref, computed, onMounted, watch } from 'vue';

const appVersion = __APP_VERSION__;
const buildTime = __BUILD_TIME__;
const weburl = __WEB_URL__;
const allPics = ref([]);
const searchQuery = ref('');
const isDarkMode = ref(false);
const isLoading = ref(true);
const error = ref(null);

// Fetch image list from server
const fetchPicsList = async () => {
  try {
    const response = await fetch(weburl + 'pics.json');
    if (!response.ok) throw new Error('获取图片列表失败');
    const data = await response.json();
    allPics.value = data.pics;
  } catch (err) {
    error.value = err.message;
    console.error('Failed to load pictures:', err);
  } finally {
    isLoading.value = false;
  }
};

// Initialize theme
onMounted(() => {
  // Check system theme preference
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
  // Check saved theme from localStorage
  const savedTheme = localStorage.getItem('theme');
  isDarkMode.value = savedTheme ? savedTheme === 'dark' : prefersDark;
  applyTheme();
  fetchPicsList();
});

// Toggle theme
const toggleTheme = () => {
  isDarkMode.value = !isDarkMode.value;
  localStorage.setItem('theme', isDarkMode.value ? 'dark' : 'light');
  applyTheme();
};

// Apply theme
const applyTheme = () => {
  document.documentElement.classList.toggle('dark-mode', isDarkMode.value);
};

// Filter images by search query
const pics_array = computed(() => {
  if (!searchQuery.value) {
    return allPics.value;
  }
  const query = searchQuery.value.toLowerCase();
  return allPics.value.filter(pic => 
    pic.toLowerCase().includes(query)
  );
});

// Handle search
const handleSearch = (query) => {
  searchQuery.value = query;
};

// Load all images when component is mounted
onMounted(() => {
  fetchPicsList();
});

</script>

<template>
  <div class="app-container">
    <header>
      <div class="header">
        <div class="header_text">IKUN 表情包大全 - 坤图大全</div>
        <div class="header-actions">
          <button 
            class="theme-toggle" 
            @click="toggleTheme"
            :aria-label="isDarkMode ? '切换到浅色模式' : '切换到深色模式'"
          >
            {{ isDarkMode ? '🌞' : '🌙' }}
          </button>
          <div class="github">
            <a href="https://github.com/wzwtt/ikun">
              <img src="./assets/github.svg" alt="在 Github 中查看本项目">
            </a>
          </div>
        </div>
      </div>
    </header>

    <div class="main-content">
      <main>
        <search :onSearch="handleSearch" />
        <div v-if="isLoading" class="loading-state">
          加载中...
        </div>
        <div v-else-if="error" class="error-state">
          {{ error }}
          <button @click="fetchPicsList" class="retry-button">重试</button>
        </div>
        <pics v-else :pics="pics_array"></pics>
      </main>
    </div>

    <footer>
      <div class="footer">
        <div class="footer_text">构建时间：{{ buildTime }} 版本：{{ appVersion }}</div>
      </div>
    </footer>
  </div>
</template>

<style>
/* Dark mode variables */
:root {
  --bg-color: #ffffff;
  --text-color: #333333;
  --header-bg: #343a40;
  --footer-bg: #f8f9fa;
  --footer-text: #6c757d;
  --card-bg: #ffffff;
  --card-shadow: rgba(0, 0, 0, 0.1);
}

:root.dark-mode {
  --bg-color: #1a1a1a;
  --text-color: #e0e0e0;
  --header-bg: #2d2d2d;
  --footer-bg: #2d2d2d;
  --footer-text: #a0a0a0;
  --card-bg: #2d2d2d;
  --card-shadow: rgba(0, 0, 0, 0.3);
}

body {
  background-color: var(--bg-color);
  color: var(--text-color);
  transition: background-color 0.3s, color 0.3s;
}
</style>

<style scoped>
.app-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  flex: 1;
}

.footer_text {
  color: var(--footer-text);
  font-size: 1rem;
  font-weight: 400;
  line-height: 1.5;
}

.footer {
  display: flex;
  align-items: center;
  bottom: 0;
  width: 100%;
  height: 56px;
  background-color: var(--footer-bg);
  padding-left: 7%;
}

.header {
  display: flex;
  flex-wrap: wrap;
  background-color: var(--header-bg);
  width: 100%;
  height: 56px;
  align-items: center;
  justify-content: space-between;
  padding-left: 7%;
  padding-right: 7%;
  margin-bottom: 20px;
}

.header_text {
  color: #ffffff;
  font-size: 20px;
  padding: 10px;
  font-weight: bold;
}

.github {
  width: 24px;
  height: 24px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 16px;
}

.theme-toggle {
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
  padding: 8px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background-color 0.3s;
}

.theme-toggle:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.loading-state,
.error-state {
  text-align: center;
  padding: 40px;
  color: var(--text-color);
}

.retry-button {
  margin-top: 16px;
  padding: 8px 16px;
  background: var(--header-bg);
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.retry-button:hover {
  background-color: #495057;
}

/* Mobile device adaptation */
@media (max-width: 768px) {
  .header_text {
    font-size: 16px;
    padding: 8px;
  }

  .github {
    width: 20px;
    height: 20px;
  }

  .header-actions {
    gap: 12px;
  }

  .theme-toggle {
    font-size: 16px;
    padding: 6px;
  }

  .header {
    padding-left: 4%;
    padding-right: 4%;
  }
}

/* Small mobile devices */
@media (max-width: 360px) {
  .header_text {
    font-size: 14px;
    padding: 6px;
  }

  .header-actions {
    gap: 8px;
  }
}
</style>
