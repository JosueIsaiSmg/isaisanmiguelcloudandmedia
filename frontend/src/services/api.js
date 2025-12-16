import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: {
    'Content-Type': 'application/json',
    'Accept-Charset': 'utf-8',
  },
});

export default {
  // Packages
  getPackages(country = 'MX') {
    return api.get(`/packages?country=${country}`);
  },
  getPackage(id) {
    return api.get(`api/packages/${id}`);
  },

  // Clients
  getClients() {
    return api.get('/clients');
  },
  getClient(id) {
    return api.get(`/clients/${id}`);
  },
  createClient(data) {
    return api.post('/clients', data);
  },
  updateClient(id, data) {
    return api.put(`/clients/${id}`, data);
  },
  deleteClient(id) {
    return api.delete(`/clients/${id}`);
  },

  // Orders
  getOrders() {
    return api.get('/orders');
  },
  getOrder(id) {
    return api.get(`/orders/${id}`);
  },
  createOrder(data) {
    return api.post('/orders', data);
  },
  updateOrder(id, data) {
    return api.put(`/orders/${id}`, data);
  },
  deleteOrder(id) {
    return api.delete(`/orders/${id}`);
  },
};