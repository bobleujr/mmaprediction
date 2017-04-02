CREATE OR REPLACE FUNCTION ft_to_cm(height text) RETURNS real AS $$
	DECLARE
		feet real;
		inches real;
		aux_str TEXT;

        BEGIN
		height = replace(replace(height, '''', ''), '"', '');

		feet = (split_part(height, ' ', 1)::integer);
		inches = (split_part(height, ' ', 2)::integer);


		RETURN feet*30.48 + inches*2.54;
        END;
$$ LANGUAGE plpgsql;