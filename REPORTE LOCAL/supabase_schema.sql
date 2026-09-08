-- Al Tanto Barquisimeto — esquema de base de datos para Supabase
-- Cómo usar: en tu proyecto de Supabase, ve a "SQL Editor" -> "New query",
-- pega todo este archivo y dale "Run". Se crea la tabla y sus permisos.

create extension if not exists pgcrypto;

create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  categoria text not null check (categoria in ('luz', 'agua', 'incidente')),
  subtipo text not null,
  zona text not null,
  severidad text check (severidad in ('leve', 'moderada', 'grave') or severidad is null),
  nota text check (char_length(nota) <= 140),
  created_at timestamptz not null default now()
);

create index if not exists reports_created_at_idx on reports (created_at desc);
create index if not exists reports_zona_idx on reports (zona);

-- Seguridad a nivel de fila: la tabla es pública de lectura y escritura
-- (reporte anónimo, sin login), pero NADIE puede editar ni borrar reportes
-- ya enviados — así se evita que alguien altere el historial de otros.
alter table reports enable row level security;

create policy "cualquiera_puede_leer" on reports
  for select using (true);

create policy "cualquiera_puede_reportar" on reports
  for insert with check (true);

-- Nota: no se crean políticas de UPDATE ni DELETE a propósito.
-- Esto significa que, por defecto, ningún visitante anónimo puede
-- modificar o borrar un reporte ya publicado.

-- Limpieza opcional: si quieres que los reportes "caduquen" solos después
-- de, digamos, 30 días, puedes programar esto como una Cron Function en
-- Supabase más adelante. No es necesario para el MVP.
