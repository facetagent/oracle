CREATE OR REPLACE PACKAGE BODY pkg_customer AS

    PROCEDURE create_customer(
        p_name  IN VARCHAR2,
        p_email IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO customer (
            name,
            email
        )
        VALUES (
            p_name,
            p_email
        );
    END create_customer;


    FUNCTION get_customer_name(
        p_customer_id IN NUMBER
    ) RETURN VARCHAR2 IS

        l_name customer.name%TYPE;

    BEGIN
        SELECT name
        INTO l_name
        FROM customer
        WHERE customer_id = p_customer_id;

        RETURN l_name;
    END get_customer_name;

END pkg_customer;
/