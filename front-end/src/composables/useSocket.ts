import { io, Socket } from 'socket.io-client'
import { API_URL } from '../config/api'

let socket: Socket | null = null

export function useSocket() {
  const connect = () => {
    if (socket?.connected) return socket

    socket = io(API_URL, {
      transports: ['websocket', 'polling'],
      autoConnect: true
    })

    socket.on('connect', () => {
      console.log('[Socket] Connected:', socket?.id)
    })

    socket.on('disconnect', () => {
      console.log('[Socket] Disconnected')
    })

    return socket
  }

  const disconnect = () => {
    if (socket) {
      socket.disconnect()
      socket = null
    }
  }

  const getSocket = () => socket

  return { connect, disconnect, getSocket }
}
