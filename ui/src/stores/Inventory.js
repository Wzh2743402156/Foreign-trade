import { defineStore } from 'pinia';

export const useInventoryStore = defineStore('inventory', {
  state: () => ({
    tags: [],
    products: [],
    factories: [],
    shops: [],
    loading: false,
    error: null
  }),
  
  getters: {
    getTagById: (state) => (id) => {
      return state.tags.find(tag => tag.id === id);
    },
    getProductById: (state) => (id) => {
      return state.products.find(product => product.id === id);
    }
  },
  
  actions: {
    async fetchTags() {
      this.loading = true;
      try {
        // In a real app, this would be an API call
        // const response = await fetch('/api/tags');
        // const data = await response.json();
        // this.tags = data;
        
        // Mock data for demonstration
        this.tags = [
          { id: 1, name: '电子产品', inbound: 150, outbound: 120, stock: 30, alert_low: 10, alert_high: 100 },
          { id: 2, name: '家具', inbound: 75, outbound: 50, stock: 25, alert_low: 5, alert_high: 50 },
          { id: 3, name: '服装', inbound: 300, outbound: 280, stock: 20, alert_low: 15, alert_high: 150 },
          { id: 4, name: '食品', inbound: 500, outbound: 490, stock: 10, alert_low: 20, alert_high: 200 },
          { id: 5, name: '玩具', inbound: 120, outbound: 100, stock: 20, alert_low: 10, alert_high: 80 }
        ];
        
        this.error = null;
      } catch (error) {
        this.error = error.message || 'Failed to fetch tags';
      } finally {
        this.loading = false;
      }
    },
    
    async fetchProducts() {
      this.loading = true;
      try {
        // In a real app, this would be an API call
        // const response = await fetch('/api/products');
        // const data = await response.json();
        // this.products = data;
        
        // Mock data for demonstration
        const mockProducts = [];
        for (let i = 1; i <= 50; i++) {
          const factoryId = Math.floor(Math.random() * 3) + 1;
          const shopId = Math.floor(Math.random() * 4) + 1;
          const status = Math.floor(Math.random() * 4) + 1;
          
          mockProducts.push({
            id: i,
            name: `商品 ${i}`,
            specification: `规格 ${i}`,
            factory_id: factoryId,
            shop_id: shopId,
            status: status,
            package_id: Math.floor(Math.random() * 100) + 1,
            tags: this.generateRandomTags(),
            remark: Math.random() > 0.7 ? `备注信息 ${i}` : ''
          });
        }
        
        this.products = mockProducts;
        this.error = null;
      } catch (error) {
        this.error = error.message || 'Failed to fetch products';
      } finally {
        this.loading = false;
      }
    },
    
    async fetchFactories() {
      this.loading = true;
      try {
        // In a real app, this would be an API call
        // const response = await fetch('/api/factories');
        // const data = await response.json();
        // this.factories = data;
        
        // Mock data for demonstration
        this.factories = [
          { id: 1, name: '北京工厂' },
          { id: 2, name: '上海工厂' },
          { id: 3, name: '广州工厂' }
        ];
        
        this.error = null;
      } catch (error) {
        this.error = error.message || 'Failed to fetch factories';
      } finally {
        this.loading = false;
      }
    },
    
    async fetchShops() {
      this.loading = true;
      try {
        // In a real app, this would be an API call
        // const response = await fetch('/api/shops');
        // const data = await response.json();
        // this.shops = data;
        
        // Mock data for demonstration
        this.shops = [
          { id: 1, name: '北京门店' },
          { id: 2, name: '上海门店' },
          { id: 3, name: '广州门店' },
          { id: 4, name: '深圳门店' }
        ];
        
        this.error = null;
      } catch (error) {
        this.error = error.message || 'Failed to fetch shops';
      } finally {
        this.loading = false;
      }
    },
    
    generateRandomTags() {
      const allTags = ['电子', '家具', '服装', '食品', '玩具', '办公', '家电', '数码', '户外', '运动'];
      const numTags = Math.floor(Math.random() * 3) + 1;
      const tags = [];
      
      for (let i = 0; i < numTags; i++) {
        const randomIndex = Math.floor(Math.random() * allTags.length);
        const tag = allTags[randomIndex];
        if (!tags.includes(tag)) {
          tags.push(tag);
        }
      }
      
      return tags;
    }
  }
});