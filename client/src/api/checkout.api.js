import axios from "axios";

const API_URL = "http://localhost:3000";

export const getCheckout = async () => {
  const res = await axios.get(`${API_URL}/checkout`);
  return res.data;
};

export const scanProduct = async (code) => {
  await axios.post(`${API_URL}/checkout/scan`, { code });
};

export const clearCheckout = async () => {
  await axios.delete(`${API_URL}/checkout`);
};
