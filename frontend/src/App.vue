<template>
  <div id="app" class="min-h-screen bg-gray-100 py-8">
    <div class="container mx-auto px-4">
      <h1 class="text-4xl font-bold text-center mb-8 text-gray-800">Cloud & Media Services</h1>
      <PricingTable :packages="packages" @select-package="handleSelectPackage" />
      <Card v-if="selectedPackage" :package="selectedPackage" @order-created="handleOrderCreated" />
    </div>
  </div>
</template>

<script>
import PricingTable from './components/PricingTable.vue';
import Card from './components/Card.vue';
import api from './services/api.js';

export default {
  name: 'App',
  components: {
    PricingTable,
    Card,
  },
  data() {
    return {
      packages: [],
      selectedPackage: null,
    };
  },
  async mounted() {
    try {
      const response = await api.getPackages();
      this.packages = response.data.packages;
    } catch (error) {
      console.error('Error loading packages:', error);
    }
  },
  methods: {
    handleSelectPackage(packageData) {
      this.selectedPackage = packageData;
    },
    handleOrderCreated() {
      this.selectedPackage = null;
      // Opcional: recargar paquetes o mostrar mensaje
    },
  },
};
</script>