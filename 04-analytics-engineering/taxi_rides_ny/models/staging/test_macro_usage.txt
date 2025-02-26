select distinct
    {{ get_payment_type_description("payment_type") }} as payment_type_description
from {{ source("staging", "green_tripdata") }}
where vendorid is not null
