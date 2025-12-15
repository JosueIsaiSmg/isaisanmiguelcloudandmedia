<template>
  <div class="pricing-table mb-8">
    <h2 class="text-2xl font-semibold mb-6 text-gray-700">Paquetes Disponibles</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div v-for="pkg in packages" :key="pkg.id" class="package-card bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow cursor-pointer border border-gray-200" @click="$emit('select-package', pkg)">
        <h3 class="text-xl font-bold mb-2 text-gray-800">{{ pkg.name }}</h3>
        <p class="text-gray-600 mb-4">{{ pkg.description }}</p>
        <p class="price text-2xl font-bold text-blue-600">${{ (pkg.price_cents / 100).toFixed(2) }} {{ pkg.currency }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'PricingTable',
  props: {
    packages: Array,
  },
  emits: ['select-package'],
};
</script>