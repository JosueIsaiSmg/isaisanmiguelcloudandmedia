<template>
  <div class="card bg-white p-6 rounded-lg shadow-md border border-gray-200">
    <h3 class="text-xl font-bold mb-4 text-gray-800">{{ package.name }}</h3>
    <p class="text-gray-600 mb-4">{{ package.description }}</p>
    <p class="text-2xl font-bold text-blue-600 mb-6">Precio: ${{ (package.price_cents / 100).toFixed(2) }} {{ package.currency }}</p>
    
    <form @submit.prevent="submitOrder" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Nombre</label>
        <input v-model="clientData.name" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Nombre completo" required />
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
        <input v-model="clientData.email" type="email" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="email@example.com" required />
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">Teléfono</label>
        <input v-model="clientData.phone" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="555-1234" required />
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">País</label>
        <select v-model="clientData.country" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
          <option value="MX">México</option>
          <option value="US">USA</option>
        </select>
      </div>
      <button type="submit" class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 transition-colors" :disabled="loading">
        {{ loading ? 'Procesando...' : 'Solicitar Orden' }}
      </button>
    </form>
  </div>
</template>

<script>
import api from '../services/api.js';

export default {
  name: 'Card',
  props: {
    package: Object,
  },
  data() {
    return {
      clientData: {
        name: '',
        email: '',
        phone: '',
        country: 'MX',
      },
      loading: false,
    };
  },
  methods: {
    async submitOrder() {
      this.loading = true;
      try {
        // Crear cliente
        const clientResponse = await api.createClient(this.clientData);
        const clientId = clientResponse.data.client_id;
        
        // Crear orden
        await api.createOrder({
          client_id: clientId,
          package_id: this.package.id,
          country: this.clientData.country,
        });
        
        alert('¡Orden creada exitosamente!');
        this.$emit('order-created');
        this.clientData = { name: '', email: '', phone: '', country: 'MX' }; // Reset form
      } catch (error) {
        console.error('Error creating order:', error);
        alert('Error al crear la orden. Revisa la consola para detalles.');
      } finally {
        this.loading = false;
      }
    },
  },
};
</script>