import axios from "axios";

const API_URL = "http://localhost:3000";

export const getRules = async () => {
  const res = await axios.get(`${API_URL}/rules`);
  return res.data;
};
