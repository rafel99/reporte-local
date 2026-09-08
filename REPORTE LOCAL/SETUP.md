# Al Tanto — Barquisimeto — Guía de puesta en marcha

Esta es una PWA (app web instalable) simple, sin frameworks ni paso de build:
son archivos estáticos que puedes editar directo desde GitHub y desplegar con
Vercel, tal como sueles trabajar.

Ahora mismo, sin tocar nada, la app funciona en **modo demostración** con
datos de ejemplo (se guardan solo en tu navegador). Para que reciba reportes
reales de la comunidad, necesitas conectar una base de datos gratuita de
Supabase — toma unos 10 minutos, una sola vez.

## 1. Crear el proyecto en Supabase

1. Entra a [supabase.com](https://supabase.com) y crea una cuenta gratis (puedes usar tu cuenta de GitHub).
2. Crea un **New Project**. Elige cualquier nombre (ej. `al-tanto-bqto`) y una contraseña de base de datos (guárdala, no la necesitarás después de este paso).
3. Espera a que el proyecto termine de aprovisionarse (1-2 minutos).

## 2. Crear la tabla de reportes

1. En el menú lateral, entra a **SQL Editor** → **New query**.
2. Abre el archivo `supabase_schema.sql` de esta carpeta, copia todo su contenido, pégalo en el editor, y dale **Run**.
3. Deberías ver "Success. No rows returned" — listo, ya existe la tabla `reports`.

## 3. Copiar tus llaves de API

1. Ve a **Project Settings** (ícono de engranaje) → **API**.
2. Copia dos valores:
   - **Project URL** (algo como `https://xxxxx.supabase.co`)
   - **anon public key** (una llave larga) — esta llave es segura de exponer en el navegador, está diseñada para eso; el acceso real lo controla la seguridad a nivel de fila que ya quedó configurada en el paso 2.

## 4. Pegar las llaves en la app

1. Abre `index.html` (puedes editarlo directo en GitHub, con el lápiz ✏️).
2. Busca estas dos líneas cerca del inicio del `<script>`:
   ```js
   const SUPABASE_URL = "";
   const SUPABASE_ANON_KEY = "";
   ```
3. Pega tus valores entre las comillas y guarda (commit).
4. Listo — la app deja el modo demostración automáticamente y empieza a leer/escribir reportes reales.

## 5. Subir a GitHub y desplegar en Vercel

1. Crea un repositorio nuevo en GitHub y sube estos archivos (arrástralos en la interfaz web: `index.html`, `manifest.json`, `sw.js`, la carpeta `icons/`).
2. En Vercel, **Add New Project** → importa ese repositorio. No necesita configuración especial: es un sitio estático, Vercel lo detecta solo.
3. Cada vez que edites un archivo desde GitHub y hagas commit, Vercel vuelve a desplegar automáticamente — tu flujo de siempre.

## 6. Mantenerla en línea (gratis, con un truco a vigilar)

**Vercel (el sitio):** el plan gratis (Hobby) incluye 100 GB de transferencia
al mes — de sobra para un piloto — y dominio propio gratis si compras uno
(Namecheap, GoDaddy, etc., ~$10-15/año) y lo conectas desde Vercel. Ojo: el
plan gratis es para uso *no comercial* (donaciones sí están permitidas,
publicidad o cobros no) — como Al Tanto no vende nada, encaja bien tal cual.

**Supabase (la base de datos):** el plan gratis da 500 MB de base de datos y
5 GB de tráfico al mes — con reportes de texto, eso alcanza para años. El
único punto a vigilar: **Supabase pausa automáticamente los proyectos
gratuitos después de una semana sin actividad.** Si el piloto arranca lento,
podría pausarse justo cuando alguien lo necesita.

La solución es gratis y toma 5 minutos: crea una cuenta en
[UptimeRobot](https://uptimerobot.com) o [cron-job.org](https://cron-job.org)
y configura un monitor que haga una petición GET cada 2-3 días a tu URL de
Supabase (`https://TU-PROYECTO.supabase.co/rest/v1/reports?select=id&limit=1`,
agregando el header `apikey: TU_ANON_KEY`). Eso cuenta como actividad y
mantiene el proyecto despierto indefinidamente, sin costo.

**Cuándo tocaría pagar algo:** solo si el uso crece mucho más allá de un
piloto en una ciudad — miles de reportes diarios o mucho tráfico. Supabase
Pro son $25/mes (sin pausas, más espacio) y Vercel Pro $20/mes (para uso
comercial o más tráfico). Para esta fase, ninguno de los dos hace falta.

## Qué esperar del MVP (y qué le falta)

Esto es un piloto pensado para validar la idea en Barquisimeto con pocos
recursos, no un producto terminado. Cosas a tener en cuenta:

- **Sin moderación**: cualquiera puede enviar un reporte, y no hay verificación (a diferencia de apps como "Hay Luz?" que usan IA para filtrar). Para un piloto pequeño esto suele ser manejable; si crece, vale la pena agregar algún filtro.
- **Zonas aproximadas**: las coordenadas de las 9 parroquias de Barquisimeto (municipio Iribarren) que vienen cargadas son aproximadas, para ubicar el punto en el mapa — no son límites oficiales. Puedes ajustarlas en el arreglo `ZONAS` dentro de `index.html`.
- **Anonimato por diseño**: no se pide login ni datos personales, a propósito — dado el contexto venezolano, es preferible que reportar un corte de luz no deje rastro de quién lo hizo.
- **Próximos pasos posibles**: reportes en tiempo real (Supabase Realtime, ya viene con tu plan gratuito, solo falta activarlo), verificación con IA de los reportes, expandir a otras ciudades reusando el mismo esquema, notificaciones push cuando vuelve la luz en tu zona.

## Números de emergencia (ya incluidos en la app)

La app deja claro que **no es una línea de emergencia**. En Barquisimeto/Lara:
- **171** — Servicio Autónomo de Emergencias de Lara
- **166** — Protección Civil (nacional)
- **167** — Bomberos (nacional)
