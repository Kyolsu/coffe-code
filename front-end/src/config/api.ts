const LOCAL_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const CLOUD_URL = import.meta.env.RENDER_API_URL || 'https://coffe-code-s7t9.onrender.com'

export const API_URL = import.meta.env.VITE_USE_CLOUD === 'true' ? CLOUD_URL : LOCAL_URL
export const USE_CLOUD = import.meta.env.VITE_USE_CLOUD === 'true'
export default API_URL