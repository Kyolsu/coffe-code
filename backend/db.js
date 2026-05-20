require('dotenv').config();
const { Pool } = require('pg');

const esLocal=process.env.DB_HOST == 'localhost';

//const pool = new Pool({
  
  //connectionString: process.env.DATABASE_URL,
  //ssl: {
    //rejectUnauthorized: false
  //}
//});

////cambios añadidos pa abajo 
const configuracionPool = esLocal 
  ? {
      // Configuración para tu computadora local
      user: process.env.DB_USER || 'postgres',
      host: process.env.DB_HOST,
      database: process.env.DB_NAME,
      password: process.env.DB_PASSWORD,
      port: parseInt(process.env.DB_PORT) || 5432,
      ssl: false
    }
  : {
      // Configuración para la nube (Supabase)
      connectionString: process.env.DATABASE_URL,
      ssl: {
        rejectUnauthorized: false //  Dejamos el SSL encendido para internet
      }
    };
    
    const pool = new Pool(configuracionPool);
/////CAMBIO Añadido pa arriba
module.exports = {
  query: (text, params) => pool.query(text, params),
};