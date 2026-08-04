CREATE OR REPLACE PACKAGE pkg_customer AS

    PROCEDURE create_customer(
        p_name  IN VARCHAR2,
        p_email IN VARCHAR2
    );

    FUNCTION get_customer_name(
        p_customer_id IN NUMBER
    ) RETURN VARCHAR2;

END pkg_customer;
/