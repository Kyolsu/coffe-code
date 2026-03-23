<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Sidebar from '../components/Sidebar.vue'
import { useAuthStore } from '../stores/auth'

const authStore = useAuthStore()
const API_URL   = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'

const ROL_LABEL: Record<number, string> = {
  1: 'Administrador',
  2: 'Gerente',
  3: 'Cajero',
  4: 'Cocinero',
}

// ── PERFIL ─────────────────────────────────────────────
interface Perfil { id: number; nombre: string; rol: number }

const perfil      = ref<Perfil | null>(null)
const cargando    = ref(false)
const errorPerfil = ref('')

const fetchPerfil = async () => {
  cargando.value    = true
  errorPerfil.value = ''
  try {
    const datos = await authStore.fetchPerfil()
    if (datos) {
      perfil.value = datos
    } else {
      errorPerfil.value = 'No se pudo obtener el perfil'
    }
  } catch {
    errorPerfil.value = 'Error al cargar perfil'
  } finally {
    cargando.value = false
  }
}

// ── TOAST ──────────────────────────────────────────────
const toast = ref<{ tipo: 'ok' | 'error'; mensaje: string } | null>(null)
let toastTimer: ReturnType<typeof setTimeout>

const mostrarToast = (tipo: 'ok' | 'error', mensaje: string) => {
  clearTimeout(toastTimer)
  toast.value = { tipo, mensaje }
  toastTimer = setTimeout(() => { toast.value = null }, 3500)
}

// ── FORM CAMBIO DE NOMBRE ──────────────────────────────
// PUT /api/usuarios/actualizar — solo cambia nuevo_nombre
// La API requiere usuario_actual + contra_actual para confirmar identidad
const modalNombre    = ref(false)
const guardandoNombre = ref(false)
const errorNombre    = ref('')

const formNombre = ref({
  contra_actual: '',
  nuevo_nombre:  '',
})

const cambiarNombre = async () => {
  guardandoNombre.value = true
  errorNombre.value     = ''

  if (!formNombre.value.nuevo_nombre.trim()) {
    errorNombre.value     = 'Ingresa el nuevo nombre de usuario'
    guardandoNombre.value = false
    return
  }

  try {
    const res = await fetch(`${API_URL}/api/usuarios/actualizar`, {
      method: 'PUT',
      headers: authStore.authHeaders(),
      body: JSON.stringify({
        usuario_actual: perfil.value?.nombre,
        contra_actual:  formNombre.value.contra_actual,
        nuevo_nombre:   formNombre.value.nuevo_nombre.trim(),
      }),
    })
    const data = await res.json()
    if (data.status === 'ok') {
      // Actualizar nombre en localStorage y store
      localStorage.setItem('coffe_nombre', formNombre.value.nuevo_nombre.trim())
      await fetchPerfil()
      cerrarModalNombre()
      mostrarToast('ok', 'Nombre de usuario actualizado')
    } else {
      errorNombre.value = data.mensaje
    }
  } catch {
    errorNombre.value = 'No se pudo conectar con el servidor'
  } finally {
    guardandoNombre.value = false
  }
}

const cerrarModalNombre = () => {
  modalNombre.value    = false
  errorNombre.value    = ''
  formNombre.value     = { contra_actual: '', nuevo_nombre: '' }
}

onMounted(fetchPerfil)
</script>

<template>
  <div class="perfil-layout">
    <Sidebar />

    <main class="perfil-main">

      <!-- HEADER -->
      <header class="page-header">
        <div>
          <p class="header-label">Cuenta</p>
          <h1 class="page-title">Mi perfil</h1>
        </div>
      </header>

      <!-- CARGANDO -->
      <div v-if="cargando" class="state-msg">Cargando perfil...</div>
      <div v-if="errorPerfil" class="error-banner">{{ errorPerfil }}</div>

      <!-- TARJETA DE PERFIL -->
      <div v-if="perfil" class="perfil-section">
        <div class="perfil-card">
          <!-- Avatar grande -->
          <div class="perfil-avatar-wrap">
            <div class="perfil-avatar">
              {{ perfil.nombre.charAt(0).toUpperCase() }}
            </div>
          </div>

          <!-- Info -->
          <div class="perfil-info">
            <div class="perfil-nombre-row">
              <h2 class="perfil-nombre">{{ perfil.nombre }}</h2>
              <button class="btn-edit-nombre" @click="modalNombre = true" title="Cambiar nombre de usuario">
                <svg viewBox="0 0 24 24" fill="none">
                  <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                  <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                Cambiar nombre
              </button>
            </div>

            <div class="perfil-meta">
              <div class="meta-item">
                <span class="meta-label">Rol</span>
                <span class="rol-pill">{{ ROL_LABEL[perfil.rol] ?? `Rol ${perfil.rol}` }}</span>
              </div>
              <div class="meta-item">
                <span class="meta-label">ID de usuario</span>
                <span class="meta-value">#{{ perfil.id }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Nota: solo nombre modificable -->
        <div class="info-card">
          <svg viewBox="0 0 24 24" fill="none">
            <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
            <path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          </svg>
          <p>Desde aquí solo puedes modificar tu nombre de usuario. El rol lo asigna el administrador y la contraseña no se muestra por seguridad.</p>
        </div>
      </div>

      <div class="watermark">
        <span>Software por</span>
        <strong>CoffeeCode</strong>
      </div>
    </main>

    <!-- ── TOAST ── -->
    <Transition name="toast">
      <div v-if="toast" class="toast" :class="`toast--${toast.tipo}`">
        <svg v-if="toast.tipo === 'ok'" viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
          <path d="M8 12l3 3 5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <svg v-else viewBox="0 0 24 24" fill="none">
          <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="1.5"/>
          <path d="M12 8v4M12 16h.01" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
        {{ toast.mensaje }}
      </div>
    </Transition>

    <!-- ── MODAL CAMBIAR NOMBRE ── -->
    <Transition name="modal">
      <div v-if="modalNombre" class="modal-overlay" @click.self="cerrarModalNombre">
        <div class="modal">
          <div class="modal-header">
            <h2>Cambiar nombre de usuario</h2>
            <button class="modal-close" @click="cerrarModalNombre">
              <svg viewBox="0 0 24 24" fill="none"><path d="M18 6L6 18M6 6l12 12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
            </button>
          </div>
          <div class="modal-body">
            <p class="hint-msg">
              Para confirmar el cambio, ingresa tu contraseña actual.
            </p>
            <div class="field">
              <label>Nuevo nombre de usuario</label>
              <input
                v-model="formNombre.nuevo_nombre"
                placeholder="nuevo_nombre"
                autocomplete="off"
                @keyup.enter="cambiarNombre"
              />
            </div>
            <div class="field">
              <label>Contraseña actual</label>
              <input
                v-model="formNombre.contra_actual"
                type="password"
                placeholder="••••••••"
                @keyup.enter="cambiarNombre"
              />
            </div>
            <div v-if="errorNombre" class="error-msg">{{ errorNombre }}</div>
          </div>
          <div class="modal-footer">
            <button class="btn-ghost" @click="cerrarModalNombre">Cancelar</button>
            <button class="btn-primary" :disabled="guardandoNombre" @click="cambiarNombre">
              <span v-if="!guardandoNombre">Guardar</span>
              <span v-else class="spinner"></span>
            </button>
          </div>
        </div>
      </div>
    </Transition>

  </div>
</template>

<style scoped>
.perfil-layout { display: flex; min-height: 100vh; background: var(--tenant-fondo, #f5f0eb); }

.perfil-main {
  flex: 1;
  padding: var(--espacio-8, 32px);
  display: flex;
  flex-direction: column;
  gap: var(--espacio-6, 24px);
  position: relative;
  overflow-y: auto;
}

/* HEADER */
.page-header { display: flex; align-items: flex-end; justify-content: space-between; }
.header-label { margin: 0; font-size: var(--font-size-xs, 11px); text-transform: uppercase; letter-spacing: 0.1em; color: var(--tenant-texto-muted, #7c6a5a); font-weight: var(--font-weight-medium, 500); }
.page-title   { margin: 0; font-size: var(--font-size-2xl, 30px); font-weight: var(--font-weight-bold, 600); color: var(--tenant-texto, #1c1410); }

.state-msg    { font-size: var(--font-size-sm, 13px); color: var(--tenant-texto-muted, #7c6a5a); }
.error-banner { background: rgba(220,38,38,0.08); border: 1px solid rgba(220,38,38,0.2); border-radius: 10px; padding: var(--espacio-3,12px) var(--espacio-4,16px); font-size: var(--font-size-sm,13px); color: var(--color-error,#dc2626); }

/* PERFIL SECTION */
.perfil-section { display: flex; flex-direction: column; gap: var(--espacio-4, 16px); max-width: 560px; }

.perfil-card {
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-radius: 20px;
  padding: var(--espacio-6, 24px);
  display: flex;
  gap: var(--espacio-5, 20px);
  align-items: flex-start;
}

.perfil-avatar-wrap { flex-shrink: 0; }

.perfil-avatar {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: rgba(194, 96, 10, 0.1);
  color: var(--tenant-primario, #c2600a);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: var(--font-size-3xl, 38px);
  font-weight: var(--font-weight-bold, 600);
  border: 2px solid rgba(194, 96, 10, 0.2);
}

.perfil-info { flex: 1; display: flex; flex-direction: column; gap: var(--espacio-4, 16px); }

.perfil-nombre-row {
  display: flex;
  align-items: center;
  gap: var(--espacio-3, 12px);
  flex-wrap: wrap;
}

.perfil-nombre {
  margin: 0;
  font-size: var(--font-size-xl, 24px);
  font-weight: var(--font-weight-bold, 600);
  color: var(--tenant-texto, #1c1410);
}

.btn-edit-nombre {
  display: flex;
  align-items: center;
  gap: var(--espacio-2, 8px);
  background: transparent;
  border: 1px solid var(--color-borde, #e8ddd5);
  color: var(--tenant-texto-muted, #7c6a5a);
  border-radius: 8px;
  padding: 4px var(--espacio-3, 12px);
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-medium, 500);
  cursor: pointer;
  font-family: var(--tenant-fuente, sans-serif);
  transition: background 0.15s, color 0.15s, border-color 0.15s;
}

.btn-edit-nombre svg { width: 13px; height: 13px; }
.btn-edit-nombre:hover { background: rgba(194,96,10,0.06); border-color: rgba(194,96,10,0.25); color: var(--tenant-primario, #c2600a); }

.perfil-meta { display: flex; flex-direction: column; gap: var(--espacio-3, 12px); }

.meta-item { display: flex; align-items: center; gap: var(--espacio-3, 12px); }

.meta-label {
  font-size: var(--font-size-xs, 11px);
  text-transform: uppercase;
  letter-spacing: 0.08em;
  font-weight: var(--font-weight-medium, 500);
  color: var(--tenant-texto-muted, #7c6a5a);
  min-width: 100px;
}

.meta-value {
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto, #1c1410);
  font-weight: var(--font-weight-medium, 500);
}

.rol-pill {
  display: inline-block;
  font-size: var(--font-size-xs, 11px);
  font-weight: var(--font-weight-bold, 600);
  background: rgba(194, 96, 10, 0.1);
  color: var(--tenant-primario, #c2600a);
  border: 1px solid rgba(194, 96, 10, 0.2);
  border-radius: 20px;
  padding: 2px 12px;
}

/* INFO CARD */
.info-card {
  display: flex;
  gap: var(--espacio-3, 12px);
  background: var(--color-superficie, #fff);
  border: 1px solid var(--color-borde, #e8ddd5);
  border-left: 3px solid var(--color-info, #2563eb);
  border-radius: 12px;
  padding: var(--espacio-4, 16px) var(--espacio-5, 20px);
  font-size: var(--font-size-sm, 13px);
  color: var(--tenant-texto-muted, #7c6a5a);
  line-height: 1.5;
  align-items: flex-start;
}

.info-card svg { width: 16px; height: 16px; color: var(--color-info, #2563eb); flex-shrink: 0; margin-top: 2px; }
.info-card p   { margin: 0; }

/* BUTTONS */
.btn-primary { display:flex; align-items:center; justify-content:center; gap:var(--espacio-2,8px); background:var(--tenant-primario,#c2600a); color:#fff; border:none; border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-bold,600); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; min-height:38px; }
.btn-primary:hover { background: #a8520a; }
.btn-primary:disabled { opacity:.6; cursor:not-allowed; }

.btn-ghost { background:transparent; border:1px solid var(--color-borde,#e8ddd5); color:var(--tenant-texto-muted,#7c6a5a); border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-4,16px); font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-medium,500); cursor:pointer; font-family:var(--tenant-fuente,sans-serif); transition:background .15s; }
.btn-ghost:hover { background:var(--color-hover,#f0ebe5); }

/* MODAL */
.modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,0.35); display:flex; align-items:center; justify-content:center; z-index:100; padding:var(--espacio-6,24px); backdrop-filter:blur(2px); }
.modal { background:var(--color-superficie,#fff); border:1px solid var(--color-borde,#e8ddd5); border-radius:20px; width:100%; max-width:400px; display:flex; flex-direction:column; overflow:hidden; box-shadow:0 24px 60px rgba(0,0,0,0.15); }
.modal-header { display:flex; align-items:center; justify-content:space-between; padding:var(--espacio-5,20px) var(--espacio-6,24px); border-bottom:1px solid var(--color-borde,#e8ddd5); }
.modal-header h2 { margin:0; font-size:var(--font-size-md,17px); font-weight:var(--font-weight-bold,600); color:var(--tenant-texto,#1c1410); }
.modal-close { background:none; border:none; cursor:pointer; color:var(--tenant-texto-muted,#7c6a5a); display:flex; padding:4px; border-radius:6px; transition:background .15s; }
.modal-close:hover { background:var(--color-hover,#f0ebe5); }
.modal-close svg { width:18px; height:18px; }
.modal-body { padding:var(--espacio-6,24px); display:flex; flex-direction:column; gap:var(--espacio-4,16px); }
.modal-footer { display:flex; gap:var(--espacio-3,12px); justify-content:flex-end; padding:var(--espacio-4,16px) var(--espacio-6,24px); border-top:1px solid var(--color-borde,#e8ddd5); }

.hint-msg { margin:0; font-size:var(--font-size-sm,13px); color:var(--tenant-texto-muted,#7c6a5a); line-height:1.5; background:var(--tenant-fondo,#f5f0eb); border-radius:8px; padding:var(--espacio-3,12px); }

.field { display:flex; flex-direction:column; gap:var(--espacio-2,8px); }
.field label { font-size:var(--font-size-xs,11px); text-transform:uppercase; letter-spacing:.08em; font-weight:var(--font-weight-medium,500); color:var(--tenant-texto-muted,#7c6a5a); }
.field input { background:var(--tenant-fondo,#f5f0eb); border:1px solid var(--color-borde,#e8ddd5); border-radius:10px; padding:var(--espacio-3,12px) var(--espacio-4,16px); font-size:var(--font-size-base,15px); color:var(--tenant-texto,#1c1410); font-family:var(--tenant-fuente,sans-serif); outline:none; transition:border-color .2s; }
.field input:focus { border-color:var(--tenant-primario,#c2600a); }

.error-msg { background:rgba(220,38,38,.08); border:1px solid rgba(220,38,38,.2); border-radius:10px; padding:var(--espacio-2,8px) var(--espacio-3,12px); font-size:var(--font-size-sm,13px); color:var(--color-error,#dc2626); }

/* TOAST */
.toast { position:fixed; bottom:var(--espacio-6,24px); left:50%; transform:translateX(-50%); display:flex; align-items:center; gap:var(--espacio-3,12px); padding:var(--espacio-3,12px) var(--espacio-5,20px); border-radius:50px; font-size:var(--font-size-sm,13px); font-weight:var(--font-weight-medium,500); z-index:200; box-shadow:0 8px 30px rgba(0,0,0,.15); white-space:nowrap; }
.toast svg { width:16px; height:16px; flex-shrink:0; }
.toast--ok    { background:var(--color-exitoso,#16a34a); color:#fff; }
.toast--error { background:var(--color-error,#dc2626);  color:#fff; }

.spinner { width:16px; height:16px; border:2px solid rgba(255,255,255,.35); border-top-color:#fff; border-radius:50%; animation:spin .7s linear infinite; display:inline-block; }
@keyframes spin { to { transform:rotate(360deg); } }

.watermark { position:absolute; bottom:var(--espacio-6,24px); right:var(--espacio-8,32px); display:flex; align-items:center; gap:var(--espacio-2,8px); font-size:var(--font-size-xs,11px); color:var(--tenant-texto-muted,#7c6a5a); pointer-events:none; }
.watermark strong { color:var(--tenant-primario,#c2600a); font-weight:var(--font-weight-bold,600); }

.modal-enter-active, .modal-leave-active { transition:opacity .2s, transform .2s; }
.modal-enter-from, .modal-leave-to { opacity:0; transform:scale(.97); }
.toast-enter-active, .toast-leave-active { transition:opacity .25s, transform .25s; }
.toast-enter-from { opacity:0; transform:translateX(-50%) translateY(12px); }
.toast-leave-to   { opacity:0; transform:translateX(-50%) translateY(12px); }
</style>