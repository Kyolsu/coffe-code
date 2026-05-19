DOCUMENTACIÓN BACKEND
# <a name="_toc229507051"></a>Importante
Antes de empezar a probar con el backend de manera local se debe instalar lo siguiente en la carpeta correspondiente

- Node JS
- Express
- Bcrypt
- Pg
- Dotenv
- JWT tokens 

Este comando descarga lo mencionado anteriormente

**npm install express pg dotenv bcrypt**

**npm install jsonwebtoken** 

**npm install cors**
# Contenido
[Importante	1](#_toc229507051)

[Usuarios	6](#_toc229507052)

[Alta	6](#_toc229507053)

[Baja	6](#_toc229507054)

[Actualizar	7](#_toc229507055)

[Mostrar perfil	7](#_toc229507056)

[Mostrar usuarios	8](#_toc229507057)

[Login	8](#_toc229507058)

[ROLES	9](#_toc229507059)

[Rol alta	9](#_toc229507060)

[Rol baja	9](#_toc229507061)

[Mostrar roles	10](#_toc229507062)

[Modificar roles	10](#_toc229507063)

[Permisos	10](#_toc229507064)

[Alta permisos	10](#_toc229507065)

[Modificar permisos	10](#_toc229507066)

[Baja permisos	11](#_toc229507067)

[Mostrar permisos	11](#_toc229507068)

[Vincular roles-permiso	11](#_toc229507069)

[Asignar permiso	11](#_toc229507070)

[Cambiar permiso	11](#_toc229507071)

[Quitar permiso	12](#_toc229507072)

[Mostrar roles-permiso	12](#_toc229507073)

[Clientes	12](#_toc229507074)

[Alta cliente	12](#_toc229507075)

[Modificar cliente	13](#_toc229507076)

[Mostrar clientes activos	13](#_toc229507077)

[Mostrar clientes inactivos	13](#_toc229507078)

[Clientes-beneficio	13](#_toc229507079)

[Mostrar	13](#_toc229507080)

[Alta	14](#_toc229507081)

[Baja	14](#_toc229507082)

[Modificar	14](#_toc229507083)

[Beneficios	15](#_toc229507084)

[Alta beneficio	15](#_toc229507085)

[Mostrar beneficios	15](#_toc229507086)

[Modificar beneficio	15](#_toc229507087)

[Eliminar beneficio	15](#_toc229507088)

[Zonas	16](#_toc229507089)

[Alta zona	16](#_toc229507090)

[Baja zona	16](#_toc229507091)

[Modificar zona	16](#_toc229507092)

[Ver zonas	17](#_toc229507093)

[Ver zonas inactivas	17](#_toc229507094)

[Categorías	17](#_toc229507095)

[Alta categorías	17](#_toc229507096)

[Baja categorías	17](#_toc229507097)

[Modificar categorías	17](#_toc229507098)

[Mostrar categorías activas	18](#_toc229507099)

[Mostrar categorías inactivas	18](#_toc229507100)

[Ingredientes	18](#_toc229507101)

[Alta ingrediente	18](#_toc229507102)

[Baja ingrediente	18](#_toc229507103)

[Modificar ingrediente	18](#_toc229507104)

[Mostrar ingredientes	19](#_toc229507105)

[Productos	19](#_toc229507106)

[Alta producto	19](#_toc229507107)

[Baja producto	19](#_toc229507108)

[Modificar producto	19](#_toc229507109)

[Mostrar productos	20](#_toc229507110)

[Mostrar productos inactivos	20](#_toc229507111)

[Ingrediente-producto	20](#_toc229507112)

[Alta ingrediente-producto	20](#_toc229507113)

[Baja ingrediente-producto	21](#_toc229507114)

[Modificar ingrediente-producto	21](#_toc229507115)

[Mostrar ingrediente-producto especifico	21](#_toc229507116)

[Mostrar todas las relaciones producto-ingrediente	21](#_toc229507117)

[Menú	21](#_toc229507118)

[Alta de menú	21](#_toc229507119)

[Baja de menú	22](#_toc229507120)

[Modificar menú	22](#_toc229507121)

[Mostrar menú activo	22](#_toc229507122)

[Mostrar menú inactivo	22](#_toc229507123)

[Mostrar menú personalizado	23](#_toc229507124)

[Menú producto	23](#_toc229507125)

[Menú producto alta	23](#_toc229507126)

[Menú producto baja	23](#_toc229507127)

[Paquetes	23](#_toc229507128)

[Alta paquete	23](#_toc229507129)

[Baja paquete	24](#_toc229507130)

[Modificar paquete	24](#_toc229507131)

[Mostrar paquetes vista comprimida	24](#_toc229507132)

[Mostrar paquetes vista completa	25](#_toc229507133)

[Paquete grupo	25](#_toc229507134)

[Mostrar paquete grupo	25](#_toc229507135)

[Alta paquete grupo	25](#_toc229507136)

[Baja paquete grupo	25](#_toc229507137)

[Modificar paquete grupo	26](#_toc229507138)

[Paquete grupo producto	26](#_toc229507139)

[Alta relación paquete grupo producto	26](#_toc229507140)

[Modificar paquete grupo producto	26](#_toc229507141)

[Baja paquete grupo producto	26](#_toc229507142)

[Mostrar todo	27](#_toc229507143)

[Promociones	27](#_toc229507144)

[Alta promoción	27](#_toc229507145)

[Modificar promoción	27](#_toc229507146)

[Baja promoción	28](#_toc229507147)

[Mostrar promociones	28](#_toc229507148)

[Promoción paquete	28](#_toc229507149)

[Mostrar promoción paquete	28](#_toc229507150)

[Alta promoción paquete	28](#_toc229507151)

[Baja promoción paquete	29](#_toc229507152)

[Promoción Cliente	29](#_toc229507153)

[Alta promoción cliente	29](#_toc229507154)

[Baja promoción cliente	29](#_toc229507155)

[Mostrar promoción cliente	30](#_toc229507156)

[Promoción productos	30](#_toc229507157)

[Alta promoción producto	30](#_toc229507158)

[Baja promoción producto	30](#_toc229507159)

[Mostrar promoción producto	30](#_toc229507160)

[Ordenes	31](#_toc229507161)

[Alta	31](#_toc229507162)

[Modificar	31](#_toc229507163)

[Eliminar	31](#_toc229507164)

[Vista ordenes	32](#_toc229507165)

[Ordenes	32](#_toc229507166)

[Ordenes cocina	32](#_toc229507167)

[Ordenes pendientes de pago	32](#_toc229507168)

[Ordenes pago	32](#_toc229507169)

[Mostrar ordenes pago	32](#_toc229507170)

[Alta orden pago	32](#_toc229507171)

[Modificar orden pago	32](#_toc229507172)

[Baja orden pago	32](#_toc229507173)

[Paquete orden selección	33](#_toc229507174)

[Mostrar orden paquete selección	33](#_toc229507175)

[Alta orden paquete selección	33](#_toc229507176)

[Modificar orden paquete selección	33](#_toc229507177)

[Eliminar orden paquete selección	33](#_toc229507178)

[Orden detalle	33](#_toc229507179)

[Mostrar ordenes detalles	33](#_toc229507180)

[Alta ordenes detalles	34](#_toc229507181)

[Baja ordenes detalles	34](#_toc229507182)

[Modificar ordenes detalles	34](#_toc229507183)

[Ordenes modificadores detalles	35](#_toc229507184)

[Mostrar ordenes modificadores detalles	35](#_toc229507185)

[Alta ordenes modificadores detalles	35](#_toc229507186)

[Baja ordenes modificadores detalles	35](#_toc229507187)

[Modificar ordenes modificadores detalles	35](#_toc229507188)

[Uso Beneficios	36](#_toc229507189)

[ALTA	36](#_toc229507190)

[MODIFICAR	36](#_toc229507191)

[BAJA	36](#_toc229507192)

[MOSTRAR	36](#_toc229507193)

[Inventario	37](#_toc229507194)

[Alta	37](#_toc229507195)

[Actualizar	37](#_toc229507196)

[Baja	37](#_toc229507197)

[Mostrar	38](#_toc229507198)

[Alta	38](#_toc229507199)


# <a name="_toc229507052"></a>Usuarios
## <a name="_toc229507053"></a>Alta
URL: [**http://localhost:3000/api/usuarios/registro**](http://localhost:3000/api/usuarios/registro)   

JSON E INFORMACIÓN ADICIONAL: 

{

`  `"usuario": "Prueba2",

`  `"contra": "123", 

`  `"rol": 1

}
## <a name="_toc229507054"></a>Baja
<URL:http://localhost:3000/api/usuarios/eliminar> 

JSON E INFORMACIÓN ADICIONAL:

{

`  `"usuario": "Prueba4",

`  `"contra": "123" 

}
## <a name="_toc229507055"></a>Actualizar 
URL: <http://localhost:3000/api/usuarios/actualizar> 

JSON E INFORMACIÓN ADICIONAL:

Ejemplo solo cambio de usuario

{

`    `"usuario\_actual": "Adrian1",

`    `"contra\_actual": "contra1",

`    `"nuevo\_nombre": "admin2"

}

Ejemplo solo cambio de contraseña

{

`    `"usuario\_actual": "admin2",

`    `"contra\_actual": "admin2",

`    `"nueva\_contra": "contra"

}

Ejemplo cambio de contraseña y usuario

{

`    `"usuario\_actual": "admin2",

`    `"contra\_actual": "contra",

`    `"nuevo\_nombre": "Adrian1",

`    `"nueva\_contra": "contra1"

}
## <a name="_toc229507056"></a>Mostrar perfil 
URL: <http://localhost:3000/api/usuarios/perfil> 

JSON E INFORMACIÓN ADICIONAL:

Este código no pide un JSON como tal, sin embargo pide un header con la siguiente información:

Una llave con el nombre auth-token con el valor del token recibido en el login, ejemplo: 

![](Aspose.Words.4d2b13c8-f03d-40a1-a89b-a15ef2303d29.001.png)

Adicionalmente agrego la información que se va a proporcionar por medio del json

{

`    `"status": "ok",

`    `"datos": {

`        `"id": 7,

`        `"nombre": "admin2",

`        `"rol": 2

`    `}

}
## <a name="_toc229507057"></a>Mostrar usuarios 
URL: <http://localhost:3000/api/usuarios/todos-usuarios> 

Ocupa auth-token, este mostrara todos los usuarios del sistema así como al rol que este vinculado. 
## <a name="_toc229507058"></a>Login
URL: <http://localhost:3000/api/usuarios/login> 

JSON E INFORMACIÓN ADICIONAL:

{

`  `"usuario": "Prueba4",

`  `"contra": "123"

` `}

Ejemplo json de respuesta

{

`    `"status": "ok",

`    `"mensaje": “Bienvenido ",

`    `"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Nywibm9tYnJlIjoiYWRtaW4yIiwicm9sIjoyLCJpYXQiOjE3NzM5ODUwNDEsImV4cCI6MTc3NDA3MTQ0MX0.A1OOl9jfkn5O9OY5UKj3eRANV6GI2GtmqI8IhdC44ic",

`    `"usuario": {

`        `"id": 7,

`        `"nombre": "admin2",

`        `"rol": 2

`    `}

}
# <a name="_toc229507059"></a>ROLES
## <a name="_toc229507060"></a>Rol alta
URL: http://localhost:3000/api/usuarios/rol/alta 

Utiliza **auth-token** 

JSON para dar de alta: 

{

"nombre\_rol":"Medico",

"descripcion":"Personal medico del restaurante"

}
## <a name="_toc229507061"></a>Rol baja 
URL: http://localhost:3000/api/usuarios/rol/baja/id

Utiliza **auth-token** 

Id es el id del rol en cuestión 

No usa JSON
## <a name="_toc229507062"></a>Mostrar roles
URL: http://localhost:3000/api/usuarios/rol/mostrar 

Utiliza **auth-token**

Entrega un JSON con id, nombre y descripción. Ejemplo de un resultado

`        `{

`            `"id\_rol": 1,

`            `"nombre\_rol": "Administrador",

`            `"descripcion": "Control total del sistema"

`        `}
## <a name="_toc229507063"></a>Modificar roles
URL: http://localhost:3000/api/usuarios/rol/modificar/id 

Id es el id del rol, por eso se entrega el id al mostrar roles

Utiliza **auth-token**

JSON para la petición:

{"nombre\_rol":"Seguridad",

"descripcion":"Guardia de seguridad del establecimiento"}
# <a name="_toc229507064"></a>Permisos
## <a name="_toc229507065"></a>Alta permisos
URL: http://localhost:3000/api/usuarios/permisos/agregar 

Ocupa **auth-token**

JSON para agregar

{

`    `"nombre\_permiso":"Limpieza"

}
## <a name="_toc229507066"></a>Modificar permisos
URL: http://localhost:3000/api/usuarios/permisos/modificar/id

Id es el id del permiso

Ocupa **auth-token**
## <a name="_toc229507067"></a>Baja permisos
URL: http://localhost:3000/api/usuarios/permisos/eliminar/id

Id es el id del permiso 

Ocupa **auth-token**
## <a name="_toc229507068"></a>Mostrar permisos
Ocupa **auth-token**

URL: http://localhost:3000/api/usuarios/permisos/mostrar 

Ejemplo de como se ve el JSON

`        `{

`            `"id\_permiso": 1,

`            `"nombre\_permiso": "crear\_pedido"

`        `},
# <a name="_toc229507069"></a>Vincular roles-permiso
## <a name="_toc229507070"></a>Asignar permiso
URL: http://localhost:3000/api/usuarios/permisos/asignar 

Ocupa **auth-token**

JSON para vincular

{

`    `"id\_rol":2,

`    `"id\_permiso":2

}
## <a name="_toc229507071"></a>Cambiar permiso
Ocupa **auth-token**

URL: http://localhost:3000/api/usuarios/permisos/cambiar

JSON de ejemplo: 

{

`    `"id\_rol":2,

`    `"id\_permiso\_viejo":2,

`    `"id\_permiso\_nuevo":3

}
## <a name="_toc229507072"></a>Quitar permiso
Ocupa **auth-token**

URL: http://localhost:3000/api/usuarios/permisos/quitar?

Ejemplo a continuación: 

http://localhost:3000/api/usuarios/permisos/quitar?id\_rol=2&id\_permiso=3

rellenar id\_rol con el rol al que se le quiere quitar el permiso, mientras id\_permiso se llena con el permiso que busquemos quitar
## <a name="_toc229507073"></a>Mostrar roles-permiso
URL: http://localhost:3000/api/usuarios/permisos/roles/mostrar 

Ocupa **auth-token**
# <a name="_toc229507074"></a>Clientes
## <a name="_toc229507075"></a>Alta cliente
URL: <http://localhost:3000/api/clientes/registro> 

JSON E INFORMACIÓN ADICIONAL:

{

`  `"nombre": "Adrian Sosa",

`  `"email": "asosa23@alumnos.uaq.mx",

`  `"telefono": "442-449-0070" 

`  `}

Agregar token para poder realizar el registro

![](Aspose.Words.4d2b13c8-f03d-40a1-a89b-a15ef2303d29.002.png)
## <a name="_toc229507076"></a>Modificar cliente
URL: http://localhost:3000/api/clientes/modificar/id

Remplazar el id por el del cliente en cuestión para modificarlo, igualmente agregar el **auth-token** del usuario

El formato de json para la modificación se muestra con el siguiente ejemplo: 

{

`  `"nombre": "Roberto calderon",

`  `"email": "roberto@1234",

`  `"telefono": "442-111-7871",

`  `"activo": false

`  `}
## <a name="_toc229507077"></a>Mostrar clientes activos
URL: http://localhost:3000/api/clientes/mostrar-activos 

No ocupa auth
## <a name="_toc229507078"></a>Mostrar clientes inactivos
URL: <http://localhost:3000/api/clientes/mostrar-inactivos> 

No ocupa auth
# <a name="_toc229507079"></a>Clientes-beneficio
## <a name="_toc229507080"></a>Mostrar
URL para mostrar:  <http://localhost:3000/api/clientes/beneficio-clientes/mostrar> 

Tomar en cuenta que ocupa el token 
## <a name="_toc229507081"></a>Alta
URL: <http://localhost:3000/api/clientes/beneficio-clientes/agregar> 

Ocupa token

JSON De referencia:

{

`    `"id\_cliente": 1,

`    `"id\_tipo\_beneficio": 1,

`    `"fecha\_inicio": "2026-04-06",

`    `"cantidad": 5,

`    `"fecha\_fin": "2026-04-30",

`    `"dias": "Lunes a Viernes"

}
## <a name="_toc229507082"></a>Baja
Dónde id es el id de la tabla beneficio-cliente

URL:http://localhost:3000/api/clientes/beneficio-clientes/desactivar/id

Ocupa token
## <a name="_toc229507083"></a>Modificar
Dónde id es el id de la tabla beneficio-cliente

URL: http://localhost:3000/api/clientes/beneficio-clientes/modificar/id

Ocupa token

JSON De referencia: 

{

`    `"disponible": 4,

`    `"usado": 1

}
# <a name="_toc229507084"></a>Beneficios
## <a name="_toc229507085"></a>Alta beneficio
URL: <http://localhost:3000/api/clientes/beneficio/registrar> 

JSON E INFORMACIÓN ADICIONAL:\
{

`    `"nombre": "descuento",

`    `"descripcion": "10% de descuento en tu proxima compra"

}
## <a name="_toc229507086"></a>Mostrar beneficios
URL: <http://localhost:3000/api/clientes/beneficio/mostrar>

Este enlace entregara directamente una lista de todos los beneficios que existen en el sistema. 
## <a name="_toc229507087"></a>Modificar beneficio 
URL: <http://localhost:3000/api/clientes/beneficio/modificar/id> 

Donde id es la id del beneficio requiere auth-token del login.  

JSON de ejemplo: 

{

`    `"nombre": "Café de Especialidad Gratis",

`    `"descripcion": "Aplica para cualquier método de extracción después de 12 visitas"

}
## <a name="_toc229507088"></a>Eliminar beneficio
URL:<http://localhost:3000/api/clientes/beneficio/eliminar/id>  

Donde id es la id del beneficio, requiere auth-token del login.  

Ejemplo de uso:

![](Aspose.Words.4d2b13c8-f03d-40a1-a89b-a15ef2303d29.003.png)
# <a name="_toc229507089"></a>Zonas
## <a name="_toc229507090"></a>Alta zona
URL: <http://localhost:3000/api/tienda/zonas/agregar> 

Utiliza auth-token 

JSON de ejemplo: \
{

`    `"nombre": "Terraza Exterior",

`    `"descripcion": "Zona pet-friendly con mesas de madera"

}
## <a name="_toc229507091"></a>Baja zona
URL: <http://localhost:3000/api/tienda/zonas/desactivar/id> 

id representa el id de la zona a desactivar

utiliza el auth-token para desactivar la zona. 
## <a name="_toc229507092"></a>Modificar zona
URL: <http://localhost:3000/api/tienda/zonas/modificar/id> 

id es el id de la zona a modificar

JSON de ejemplo para modificar, utiliza auth-token

{

`    `"nombre": "Terraza Exterior",

`    `"descripcion": "Zona exterior con mesas de plastico",

`    `"activo": true

}
## <a name="_toc229507093"></a>Ver zonas
URL: <http://localhost:3000/api/tienda/zonas/mostrar> 

No utiliza token auth, arroja todas las zonas de la tienda.
## <a name="_toc229507094"></a>Ver zonas inactivas
URL: <http://localhost:3000/api/tienda/zonas/mostrar-inactivas> 

No utiliza token-auth, arroja todas las zonas inactivas de la tienda. 
# <a name="_toc229507095"></a>Categorías 
## <a name="_toc229507096"></a>Alta categorías
URL: <http://localhost:3000/api/tienda/categorias/agregar> 

JSON DE EJEMPLO OCUPA LA FUNCIÓN AUTH-TOKEN

{

`    `"nombre": "Birria",

`    `"descripcion": "Birria de temporada"

}
## <a name="_toc229507097"></a>Baja categorías
URL: <http://localhost:3000/api/tienda/categorias/desactivar/id> 

id es el id de la categoría, ocupa auth-token. No ocupa el JSON: 
## <a name="_toc229507098"></a>Modificar categorías
URL: <http://localhost:3000/api/tienda/categorias/modificar/id> 

id es el id de la categoría, ocupa auth-token. Ejemplo de JSON: 

{

`    `"nombre":"Menudo",

`    `"descripcion":"Menudo de temporada",

`    `"activo":true

}
## <a name="_toc229507099"></a>Mostrar categorías activas 
URL: <http://localhost:3000/api/tienda/categorias/mostrar> 

No utiliza token auth, muestra todas las categorías que existen de productos
## <a name="_toc229507100"></a>Mostrar categorías inactivas 
URL: <http://localhost:3000/api/tienda/categorias/mostrar-inactivas> 

No utiliza token auth, muestra todas las categorías inactivas que existen de productos
# <a name="_toc229507101"></a>Ingredientes
## <a name="_toc229507102"></a>Alta ingrediente
URL: <http://localhost:3000/api/productos/ingrediente/agregar>

Requiere **auth-token**

Ejemplo de JSON a enviar

{

`    `"nombre": "Azucar",

`    `"tipo": "opcional",

`    `"precio": 0

}

## <a name="_toc229507103"></a>Baja ingrediente
URL: <http://localhost:3000/api/productos/ingrediente/desactivar/id> 

Dónde id es el ingrediente para desactivar, utiliza **auth-token**
## <a name="_toc229507104"></a>Modificar ingrediente
URL: <http://localhost:3000/api/productos/ingrediente/actualizar/id> 

Dónde id es el ingrediente que modificar, utiliza **auth-token,** ejemplo de formato del JSON: 

{

`    `"precio": 0,

`    `"activo": true,

`    `"estado":"Disponible"

}
## <a name="_toc229507105"></a>Mostrar ingredientes
URL: <http://localhost:3000/api/productos/ingredientes/mostrar> 

No utiliza JSON ni auth token 
# <a name="_toc229507106"></a>Productos
## <a name="_toc229507107"></a>Alta producto
URL: <http://localhost:3000/api/productos/agregar> 

Ocupa auth-token, JSON de ejemplo: 

{

`    `"nombre": "Cafe americano",

`    `"descripcion": "Delicioso café de americano",

`    `"precio": 15,

`    `"id\_zona": 2,

`    `"id\_categoria": 2,

`    `"url\_imagen": "aqui deberia ir el cafe americano"

}
## <a name="_toc229507108"></a>Baja producto
URL: <http://localhost:3000/api/productos/desactivar/id> 

id del producto que busquemos modificar, utiliza auth-token
## <a name="_toc229507109"></a>Modificar producto
URL: <http://localhost:3000/api/productos/modificar/id> 

ID del producto que busquemos modificar, utiliza auth-token

JSON de ejemplo: 

{

`    `"nombre": "Frappe de guanabana (Grande)",

`    `"descripcion": "Frappe especial de temporada",

`    `"precio": 60.00,

`    `"id\_zona": 1,

`    `"id\_categoria": 2,

`    `"url\_imagen": "frappe\_guanabanajpg",

`    `"disponibilidad": true

}
## <a name="_toc229507110"></a>Mostrar productos
URL: <http://localhost:3000/api/productos/mostrar> 

No ocupa auth-token ni JSON
## <a name="_toc229507111"></a>Mostrar productos inactivos
URL: <http://localhost:3000/api/productos/mostrar-inactivo> 

No ocupa auth-token ni JSON
# <a name="_toc229507112"></a>Ingrediente-producto 
## <a name="_toc229507113"></a>Alta ingrediente-producto
URL: <http://localhost:3000/api/productos/producto-ingrediente/vincular> 

Ocupa auth-token, JSON de ejemplo: 

{

`    `"id\_producto":2,

`    `"id\_ingrediente":6,

`    `"es\_obligatorio": false,

`    `"precio": 0.0

}
## <a name="_toc229507114"></a>Baja ingrediente-producto
URL: <http://localhost:3000/api/productos/producto-ingrediente/desvincular/id> 

Donde el id es el id producto\_ingrediente de la tabla permitiendo desvincular/desactivar relaciones entre productos e ingredientes utiliza auth-token y no requiere JSON.
## <a name="_toc229507115"></a>Modificar ingrediente-producto
URL: <http://localhost:3000/api/productos/producto-ingrediente/modificar/id> 

Donde el id es el id producto\_ingrediente de la tabla permitiendo modificar algunos detalles, utiliza auth-token.

JSON de ejemplo: 

{

`    `"precio": 0.5,

`    `"activo":false,

`    `"es\_obligatorio":true  

}
## <a name="_toc229507116"></a>Mostrar ingrediente-producto especifico
URL: <http://localhost:3000/api/productos/producto-ingrediente/mostrar-especifico/id> 

Id del producto que queremos ver sus ingredientes. Ocupa **token auth**, arrojara todos los ingredientes que tiene ese producto. Útil para los menús de las comidas. 
## <a name="_toc229507117"></a>Mostrar todas las relaciones producto-ingrediente
URL: <http://localhost:3000/api/productos/producto-ingrediente/mostrar> 

Nos permite ver todas las relaciones entre los distintos productos, útil para eliminar relaciones o modificarlas. No requiere auth-token ni JSON
# <a name="_toc229507118"></a>Menú
## <a name="_toc229507119"></a>Alta de menú 
URL: <http://localhost:3000/api/menu/agregar> 

Utiliza **auth-token**

JSON:

{

`    `"nombre": "Menú Ejecutivo",

`    `"descripcion": "Incluye sopa, plato fuerte y bebida",

`    `"hora\_inicio": "13:00:00",

`    `"hora\_fin": "16:00:00",

`    `"dias\_semana": "Lunes-Viernes",

`    `"fecha\_inicio": "2026-03-01",

`    `"fecha\_fin": "2026-12-31"

}
## <a name="_toc229507120"></a>Baja de menú 
URL: <http://localhost:3000/api/menu/desactivar/id> 

El id identifica el menú a desactivar

Ocupa **auth-token** 
## <a name="_toc229507121"></a>Modificar menú 
URL: <http://localhost:3000/api/menu/modificar/id> 

El id identifica el menú a desactivar 

Ocupa **auth-token** 

JSON de ejemplo, pero se pueden cambiar todos los valores del JSON alta de menú 

{

`    `"nombre": "Menú de Verano",

`    `"activo": true

}
## <a name="_toc229507122"></a>Mostrar menú activo 
URL: <http://localhost:3000/api/menu/mostrar-activo> 
## <a name="_toc229507123"></a>Mostrar menú inactivo 
URL: <http://localhost:3000/api/menu/mostrar-inactivo> 
## <a name="_toc229507124"></a>Mostrar menú personalizado
URL: <http://localhost:3000/api/menu/mostrar-menu/id>

Id es el id del menú que se busque mostrar
# <a name="_toc229507125"></a>Menú producto
## <a name="_toc229507126"></a>Menú producto alta
URL: <http://localhost:3000/api/menu/menu-producto/agregar> 

Requiere auth-token

JSON para agregar producto: 

{

`    `"id\_menu":5,

`    `"id\_producto":1

}
## <a name="_toc229507127"></a>Menú producto baja 
URL: <http://localhost:3000/api/menu/menu-producto/retirar?id_menu=5&id_producto=1> 

Remplazar el número 5 y 1 por los IDs correspondientes al menú y el producto que queremos retirar de este menú. 
# <a name="_toc229507128"></a>Paquetes
## <a name="_toc229507129"></a>Alta paquete
URL: <http://localhost:3000/api/paquetes/agregar> 

Al ser una función para agregar nuevos, se requiere un token así como un JSON: 

{

`    `"nombre": "Paquete el java",

`    `"descripcion": "Comida corrida mas postre",

`    `"precio": 85.00,

`    `"es\_temporal": true,

`    `"fecha\_inicio": "2026-04-01 08:00:00",

`    `"fecha\_fin": "2026-04-07 20:00:00",

`    `"url\_imagen": "https://coffeecode.com/java.jpg"

}

Igualmente pueden ser indefinidos en ese caso se utilizaría un json como este

{

`    `"nombre": "Combo Mañanero",

`    `"descripcion": "Café americano chico y una dona de chocolate",

`    `"precio": 45.00,

`    `"es\_temporal": false,

`    `"dias\_disponibles": "Lunes a Viernes"

}
## <a name="_toc229507130"></a>Baja paquete
URL: <http://localhost:3000/api/paquetes/desactivar/id> 

Dónde id es la id del paquete 

Igualmente requiere verificación, pero no requiere JSON
## <a name="_toc229507131"></a>Modificar paquete
URL: <http://localhost:3000/api/paquetes/actualizar/id> 

Dónde id es el id del paquete

Requiere verificación además de un JSON como este, simplemente remplazaremos los valores que queramos modificar:

{

`    `"precio": 49.90,

`    `"nombre": "Paquete el rio",

`    `"es\_temporal": false,

`    `"activo": true }
## <a name="_toc229507132"></a>Mostrar paquetes vista comprimida
URL: <http://localhost:3000/api/paquetes/vista-comprimida> 

Al ser un mostrar no ocupa JSON, la diferencia con esta función y la siguiente, es que únicamente entrega una tabla con sus características más importantes. 
##
## <a name="_toc229507133"></a>Mostrar paquetes vista completa
URL: <http://localhost:3000/api/paquetes/vista-completa> 

Al ser un mostrar no ocupa json, la diferencia con esta función y la anterior es que esta arroja una tabla completa con todas sus características. 
# <a name="_toc229507134"></a>Paquete grupo
## <a name="_toc229507135"></a>Mostrar paquete grupo
<http://localhost:3000/api/paquetes/grupo/mostrar/id> 

Dónde id es el id del paquete que queremos ver sus grupos 

Utiliza verificación, pero no lleva JSON.
## <a name="_toc229507136"></a>Alta paquete grupo
Utilizar un JSON con el siguiente formato, igualmente recordar la verificación del token.

El objetivo de esto es tener grupos independientes para cada producto. 

{

`    `"id\_paquete": 3,

`    `"nombre\_grupo": "bebida caliente",

`    `"es\_obligatorio": true,

`    `"cantidad": 1

}

## <a name="_toc229507137"></a>Baja paquete grupo 
Para desactivar un paquete lo que tenemos que hacer es utilizar el id del paquete-grupo de la tabla, este se puede ver mediante el endpoint mostrar paquete grupo

URL: <http://localhost:3000/api/paquetes/grupos/desactivar/id> 

id es el id del paquete grupo en cuestión
## <a name="_toc229507138"></a>Modificar paquete grupo
URL: <http://localhost:3000/api/paquetes/grupos/modificar/id> 

Dónde el id es el del grupo id paquete grupo, tomar en cuenta que se requiere verificación así como JSON para las modificaciones, ejemplo: 

<http://localhost:3000/api/paquetes/grupos/modificar/id> 
# <a name="_toc229507139"></a>Paquete grupo producto
## <a name="_toc229507140"></a>Alta relación paquete grupo producto
URL: <http://localhost:3000/api/paquetes/grupos-productos/vincular> 

Para establecer la relación vinculamos un producto con un grupo. Para esto necesitamos utilizar el token de verificación, además de un json con este formato:\
{

`    `"id\_grupo": 2,

`    `"id\_producto": 2,

`    `"precio\_adicional": 0

}
## <a name="_toc229507141"></a>Modificar paquete grupo producto
URL: <http://localhost:3000/api/paquetes/grupos-productos/modificar> 

Ocupa verificación, así como el JSON de cambios, ejemplo: 

{

`    `"id\_grupo": 2,

`    `"id\_producto": 2,

`    `"precio": 15.00

}
## <a name="_toc229507142"></a>Baja paquete grupo producto
URL: <http://localhost:3000/api/paquetes/grupos-productos/desvincular> 

Esta función permite desvincular dos ids mediante el id del grupo y producto, por lo tanto, utiliza un JSON y la verificación de token. JSON de ejemplo: 

{

`    `"id\_grupo": 2,

`    `"id\_producto": 2

}
## <a name="_toc229507143"></a>Mostrar todo 
Esta función nos permite ver todos los productos dentro de un grupo, los grupos de un paquete y todos los paquetes.

Este funciona sin verificar token, pero ocupa la URL: <http://localhost:3000/api/paquetes/menu-completo> 
# <a name="_toc229507144"></a>Promociones
## <a name="_toc229507145"></a>Alta promoción
URL: <http://localhost:3000/api/promociones/agregar> 

Para el alta se utiliza verificación de token, además de un JSON como el siguiente: 

{

`    `"nombre": "Hora feliz cafetera",

`    `"descripcion": "2x1 en capuchinos de 4pm a 6pm",

`    `"tipo": "2x1",

`    `"valor": 50,

`    `"hora\_inicio": "16:00:00",

`    `"hora\_fin": "18:00:00",

`    `"dias": ["Lunes", "Martes", "Miércoles"],

`    `"solo\_clientes": false

}
## <a name="_toc229507146"></a>Modificar promoción
Donde id es el id de la promoción 

URL:  <http://localhost:3000/api/promociones/modificar/id> 

Ejemplo de una JSON de modificación, este utiliza token de verificación, además tomar en cuenta que se pueden colocar solo los puntos que se quieren modificar. 

{

`    `"nombre": "Hora feliz cafetera",

`    `"descripcion": "2x1 en capuchinos de 4pm a 6pm",

`    `"tipo": "2x1",

`    `"valor": 50,

`    `"hora\_inicio": "16:00:00",

`    `"hora\_fin": "18:00:00",

`    `"dias": ["Viernes", "Sabado", "Domingo"],

`    `"solo\_clientes": true

}
## <a name="_toc229507147"></a>Baja promoción 
Donde id es el id de la promoción 

URL: <http://localhost:3000/api/promociones/eliminar/id> 

Esta baja borra directamente la promoción, no tiene botón de desactivar por alguna razón. 
## <a name="_toc229507148"></a>Mostrar promociones
URL: <http://localhost:3000/api/promociones/mostrar> 

No utiliza token, muestra todas las promociones que existen
# <a name="_toc229507149"></a>Promoción paquete
## <a name="_toc229507150"></a>Mostrar promoción paquete
Utiliza token

URL: <http://localhost:3000/api/promociones/paquetes/mostrar> 
## <a name="_toc229507151"></a>Alta promoción paquete
URL: <http://localhost:3000/api/promociones/paquetes/vincular> 

Utiliza token para la verificación, JSON de referencia: 

{

`    `"id\_promocion": 1,

`    `"id\_paquete": 3

}
## <a name="_toc229507152"></a>Baja promoción paquete
URL: <http://localhost:3000/api/promociones/paquetes/desvincular> 

Utiliza token

Es el mismo JSON que para el alta, solo que este se encarga de eliminar el vinculo: 

{

`    `"id\_promocion": 1,

`    `"id\_paquete": 3

}
# <a name="_toc229507153"></a>Promoción Cliente
## <a name="_toc229507154"></a>Alta promoción cliente
URL: <http://localhost:3000/api/promociones/clientes/vincular> 

JSON de referencia, además ocupa token

{

`    `"id\_promocion": 3,

`    `"id\_cliente": 2

}
##
## <a name="_toc229507155"></a>Baja promoción cliente
URL: <http://localhost:3000/api/promociones/clientes/desvincular> 

JSON de referencia, además ocupa token

{

`    `"id\_promocion": 3,

`    `"id\_cliente": 2

}
## <a name="_toc229507156"></a>Mostrar promoción cliente 
Utiliza token

URL : <http://localhost:3000/api/promociones/clientes/mostrar> 
# <a name="_toc229507157"></a>Promoción productos 
## <a name="_toc229507158"></a>Alta promoción producto
URL: <http://localhost:3000/api/promociones/productos/vincular> 

Utiliza token de verificación y JSON:  

{

`    `"id\_promocion": 1,

`    `"id\_producto": 2

}
## <a name="_toc229507159"></a>Baja promoción producto
URL: <http://localhost:3000/api/promociones/productos/desvincular> 

Utiliza token de verificación y JSON:  

{

`    `"id\_promocion": 1,

`    `"id\_producto": 2

}
## <a name="_toc229507160"></a>Mostrar promoción producto  
URL: <http://localhost:3000/api/promociones/productos/mostrar> 

Utiliza token de verificación y JSON:  

{

`    `"id\_promocion": 1,

`    `"id\_producto": 2

}
# <a name="_toc229507161"></a>Ordenes
## <a name="_toc229507162"></a>Alta
URL: <http://localhost:3000/api/ordenes/agregar> 

JSON, igualmente ocupa token de verificación

{

`    `"numero\_orden": "TICKET-001",

`    `"subtotal": 150.00,

`    `"total": 174.00,

`    `"tipo\_orden": "local",

`    `"mesa\_numero": "Mesa 5",

`    `"impuestos": 24.00,

`    `"notas": "Sin cebolla en el bagel y café muy caliente"

}
## <a name="_toc229507163"></a>Modificar
URL: <http://localhost:3000/api/ordenes/modificar/ID> 

Al modificar nuestra orden necesitamos el ID de orden, este se puede ver mediante las vistas descritas abajo: 

JSON de ejemplo: 

{

`    `"estado\_pago":"pagado",

`    `"metodo\_pago":"tarjeta",

`    `"estado\_orden": "entregada",

`    `"fecha\_entrega": "2026-04-10 16:30:00"

}
## <a name="_toc229507164"></a>Eliminar
URL: <http://localhost:3000/api/ordenes/cancelar/id> 

Igualmente aquí utilizamos el id del 
# <a name="_toc229507165"></a>Vista ordenes
## <a name="_toc229507166"></a>Ordenes
URL: <http://localhost:3000/api/ordenes/mostrar> 

Entregara una lista de ordenes
## <a name="_toc229507167"></a>Ordenes cocina
URL: <http://localhost:3000/api/ordenes/cocina> 
## <a name="_toc229507168"></a>Ordenes pendientes de pago
URL: <http://localhost:3000/api/ordenes/pendientes-pago>
# <a name="_toc229507169"></a>Ordenes pago
## <a name="_toc229507170"></a>Mostrar ordenes pago
URL: <http://localhost:3000/api/ordenes/pagos/mostrar> 

Utiliza token de verificación
## <a name="_toc229507171"></a>Alta orden pago
URL: <http://localhost:3000/api/ordenes/pagos/agregar> 

JSON de referencia:

{

`    `"id\_orden": 3,

`    `"metodo": "tarjeta",

`    `"monto": 70,

`    `"referencia": "TRANS-987456"

}
## <a name="_toc229507172"></a>Modificar orden pago
URL: <http://localhost:3000/api/ordenes/pagos/modificar/id> 

Dónde id es el numero de pago
## <a name="_toc229507173"></a>Baja orden pago
URL: <http://localhost:3000/api/ordenes/pagos/cancelar/id> 

Dónde id es el numero de pago
# <a name="_toc229507174"></a>Paquete orden selección 
## <a name="_toc229507175"></a>Mostrar orden paquete selección
URL: <http://localhost:3000/api/ordenes/paquete-seleccion/mostrar>

Utiliza token de verificación 
## <a name="_toc229507176"></a>Alta orden paquete selección
URL: <http://localhost:3000/api/ordenes/paquete-seleccion/agregar>

Utiliza token de verificación 

JSON

{

`    `"id\_detalle": 1,

`    `"id\_grupo": 2,

`    `"id\_producto": 4,

`    `"cantidad": 1

}
## <a name="_toc229507177"></a>Modificar orden paquete selección
URL: <http://localhost:3000/api/ordenes/paquete-seleccion/modificar/id>

{

"cantidad": 2

}
## <a name="_toc229507178"></a>Eliminar orden paquete selección
<http://localhost:3000/api/ordenes/paquete-seleccion/cancelar/id> 
# <a name="_toc229507179"></a>Orden detalle
## <a name="_toc229507180"></a>Mostrar ordenes detalles
URL: <http://localhost:3000/api/ordenes/detalles/mostrar> 

Ocupa verificar token 
## <a name="_toc229507181"></a>Alta ordenes detalles
URL: <http://localhost:3000/api/ordenes/detalles/agregar> 

JSON, Requiere verificación :

{

`    `"id\_orden": 3,

`    `"cantidad": 2,

`    `"precio\_unitario": 45.00,

`    `"subtotal": 90.00,

`    `"id\_producto": 3,

`    `"notas": "Uno con leche de almendras"

}
## <a name="_toc229507182"></a>Baja ordenes detalles
URL: <http://localhost:3000/api/ordenes/detalles/cancelar/id> 

Dónde id es el id de la tabla ordenes detalle
## <a name="_toc229507183"></a>Modificar ordenes detalles
URL: <http://localhost:3000/api/ordenes/detalles/modificar/id> 

Dónde id es el id de la tabla orden detalle

JSON: 

{

`    `"id\_orden": 3,

`    `"cantidad": 1,

`    `"precio\_unitario": 15.00,

`    `"subtotal": 90.00,

`    `"id\_producto": 2,

`    `"notas": "Con platano"

}
# <a name="_toc229507184"></a>Ordenes modificadores detalles
## <a name="_toc229507185"></a>Mostrar ordenes modificadores detalles
URL: <http://localhost:3000/api/ordenes/detalles-modificadores/mostrar> 

Ocupa token de verificación
## <a name="_toc229507186"></a>Alta ordenes modificadores detalles
URL: <http://localhost:3000/api/ordenes/detalles-modificadores/> 

Ocupa token de verificación

JSON:

{

`    `"id\_detalle": 1,

`    `"id\_ingrediente": 1,

`    `"accion": "agregar",

`    `"precio": 15.00

}
## <a name="_toc229507187"></a>Baja ordenes modificadores detalles
URL: <http://localhost:3000/api/ordenes/detalles-modificadores/id> 

Dónde el id es el id detalle modificador
## <a name="_toc229507188"></a>Modificar ordenes modificadores detalles
URL: <http://localhost:3000/api/ordenes/detalles-modificadores/id> 

Dónde el id es el id detalle modificador

JSON de ejemplo, utiliza verificación : \
{

`    `"id\_detalle": 1,

`    `"id\_ingrediente": 1,

`    `"accion": "agregar",

`    `"precio": 3.00

}
# <a name="_toc229507189"></a>Uso Beneficios 
## <a name="_toc229507190"></a>ALTA
URL: <http://localhost:3000/api/clientes/beneficios/uso> 

{

`    `"id\_cliente\_beneficio": 2,

`    `"id\_orden": 1,

`    `"cantidad": 1

}

Usa auth-token 
## <a name="_toc229507191"></a>MODIFICAR
Url: <http://localhost:3000/api/clientes/beneficios/uso/id> 

Donde id es el id del uso beneficio
## <a name="_toc229507192"></a>BAJA
URL: <http://localhost:3000/api/clientes/beneficios/uso/id> 

donde id es el id de uso beneficio, usa auth-token 
## <a name="_toc229507193"></a>MOSTRAR
URL: <http://localhost:3000/api/clientes/beneficios/uso> utiliza auth-token


# <a name="_toc229507194"></a>Inventario
# <a name="_toc229507195"></a>Alta
URL: <http://localhost:3000/api/inventario/agregar> 

JSON E INFORMACIÓN ADICIONAL: 

{

`    `"id\_ingrediente": 2,

`    `"cantidad\_actual": 10.5,

`    `"cantidad\_minima": 2.0,

`    `"unidad": "kg"

}

Utiliza auth-token
# <a name="_toc229507196"></a>Actualizar
URL: <http://localhost:3000/api/inventario/actualizar/1> 

JSON E INFORMACIÓN ADICIONAL:

{

`    `"id\_ingrediente": 2,

`    `"cantidad\_actual": 9.5,

`    `"cantidad\_minima": 2.0,

`    `"unidad": "kg"

}

Id es id de actualizar
# <a name="_toc229507197"></a>Baja
URL: <http://localhost:3000/api/inventario/desactivar/1> 

JSON E INFORMACIÓN ADICIONAL: Usa auth-token el id es el id inventario

# <a name="_toc229507198"></a>Mostrar
URL: <http://localhost:3000/api/inventario/mostrar> 

JSON E INFORMACIÓN ADICIONAL: usa auth token 
# <a name="_toc229507199"></a>Alta 
URL: <http://localhost:3000/api/inventario/movimientos> 

JSON E INFORMACIÓN ADICIONAL:

Igualmente tomar en cuenta que esta alta igual afecta los objetos de la tabla de inventario normal, la movimientos solo es en caso de registros recurrentes

{

`    `"id\_inventario": 2,

`    `"tipo\_movimiento": "entrada",

`    `"cantidad": 40,

`    `"motivo": "Compra mensual de pollo "

}

` `usa auth token 




