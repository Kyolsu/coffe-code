// Simulamos los datos que algún día nos dará la base de datos
const MOCK_PRODUCTS = [
  { id: 1, nombre: 'Café Americano', precio: 25, categoria: 'Bebidas' },
  { id: 2, nombre: 'Chilaquiles', precio: 65, categoria: 'Comida' },
]

export const obtenerProductos = async () => {
  // Leemos el .env (ej. VITE_USE_MOCKS=true)
  const useMocks = import.meta.env.VITE_USE_MOCKS === 'true'

  if (useMocks) {
    // Si estamos en modo Mock, devolvemos la data falsa simulando que tardó 500ms
    return new Promise((resolve) => setTimeout(() => resolve(MOCK_PRODUCTS), 500))
  } else {
    // Cuando la API esté lista, esto se ejecutará. ¡Tu componente Vue nunca se entera del cambio!
    const baseUrl = import.meta.env.VITE_API_URL
    const response = await fetch(`${baseUrl}/productos`)
    return await response.json()
  }
}
