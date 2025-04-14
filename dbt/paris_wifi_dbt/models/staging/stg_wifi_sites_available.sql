-- This staging model selects and renames relevant fields from the wifi sites table
-- to standardize their usage in downstream models and visualizations.

with source as (

    select * from {{ source('paris_wifi_dataset', 'wifi_sites_available') }}

),

renamed as (

    select
        Nom_du_site as site_name,
        Adresse as address,
        cast(Code_postal as string) as district,
        Nombre_de_bornes as terminal_count,
        Etat_du_site as site_status

    from source

)

select * from renamed