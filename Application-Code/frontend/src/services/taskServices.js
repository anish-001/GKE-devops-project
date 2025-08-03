import axios from "axios";

// Configure API URL with fallback
const apiUrl = process.env.REACT_APP_BACKEND_URL || "http://localhost:3500/api/tasks";

// Create axios instance with default config
const api = axios.create({
    baseURL: apiUrl,
    timeout: 10000,
    headers: {
        'Content-Type': 'application/json',
    }
});

// Add request interceptor for logging
api.interceptors.request.use(
    (config) => {
        console.log(`Making ${config.method?.toUpperCase()} request to ${config.url}`);
        return config;
    },
    (error) => {
        console.error('Request error:', error);
        return Promise.reject(error);
    }
);

// Add response interceptor for error handling
api.interceptors.response.use(
    (response) => {
        return response;
    },
    (error) => {
        console.error('Response error:', error);
        return Promise.reject(error);
    }
);

export function getTasks() {
    return api.get("/");
}

export function addTask(task) {
    return api.post("/", task);
}

export function updateTask(id, task) {
    return api.put(`/${id}`, task);
}

export function deleteTask(id) {
    return api.delete(`/${id}`);
}
