import axios from "axios";

const api = axios.create({
  baseURL: "http://projecthub-alb-663164636.us-east-1.elb.amazonaws.com"
});

export default api;
