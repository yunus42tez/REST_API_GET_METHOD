*&---------------------------------------------------------------------*
*& Report ZYT_OIL_PRICES_IN_ISTANBUL_API
*&---------------------------------------------------------------------*
*&
*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    Notes    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*&
*& You can call this api 15 times in a month.
*& The original link is here:
*& https://rapidapi.com/scaefy-web-agency-scaefy-web-agency-default/api/akaryakit-fiyatlari/playground/apiendpoint_d1a0da94-163e-42a1-82b5-2103ec8b1fb8
*& the result is in character format.
*&---------------------------------------------------------------------*
REPORT ZYT_OIL_PRICES_IN_ISTANBUL_API.


TYPE-POOLS: abap.

DATA: crlf TYPE abap_cr_lf VALUE cl_abap_char_utilities=>cr_lf.

DATA: lv_url          TYPE string,
      lv_result(9999) TYPE c,
      lv_output       TYPE string.

DATA: lt_lines TYPE TABLE OF string.


TRY.


* API URL
    lv_url = 'https://akaryakit-fiyatlari.p.rapidapi.com/fuel/istanbul'.
    DATA: o_client TYPE REF TO if_http_client.

*CREATE HTTP OBJECT
    cl_http_client=>create_by_url( EXPORTING
                                     url = lv_url
                                   IMPORTING
                                     client = o_client
                                   EXCEPTIONS
                                     argument_not_found = 1
                                     plugin_not_active = 2
                                     internal_error = 3
                                   OTHERS = 4 ).

    IF sy-subrc EQ 0.
      o_client->close( ).
    ENDIF.

    IF o_client IS BOUND.

*SET HTTP METHOD
      o_client->request->set_method( if_http_request=>co_request_method_get ).


*SET HEADER FIELDS

      o_client->request->set_header_field( name  = 'x-rapidapi-host'
                                           value = 'akaryakit-fiyatlari.p.rapidapi.com' ).

      o_client->request->set_header_field( name  = 'x-rapidapi-key'
                                           value = '8f31f4d54bmsh33660089bcb6d1fp10dccejsn40009f519be6' ).


*SET TIMEOUT
      o_client->send( timeout = if_http_client=>co_timeout_default ).

*READ RESPONSE, HTTP_STATUS, PAYLOAD
      o_client->receive( ).
      DATA: lv_http_status TYPE i,
            lv_status_text TYPE string.

      o_client->response->get_status( IMPORTING
                                          code   = lv_http_status
                                          reason = lv_status_text ).

      WRITE: / 'HTTP_STATUS_CODE: ', lv_http_status.
      WRITE: / 'STATUS_TEXT: ', lv_status_text.

      IF lv_http_status EQ 200.
        lv_result = o_client->response->get_cdata( ).
      ENDIF.

*SPLIT THE LONG TEXT
      REPLACE ALL OCCURRENCES OF '}' IN lv_result WITH crlf.

      SPLIT lv_result AT cl_abap_char_utilities=>cr_lf INTO TABLE lt_lines.


      WRITE: / 'Response: '.

      LOOP AT lt_lines INTO lv_output.
        WRITE: / lv_output.
      ENDLOOP.


*CLOSE HTTP CONNECTION
      o_client->close( ).
    ENDIF.


  CATCH cx_root INTO DATA(e_txt).


    WRITE: / e_txt->get_text( ).
ENDTRY.
