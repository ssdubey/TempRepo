#define CAML_NAME_SPACE
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <caml/memory.h>
#include <caml/alloc.h>
#include <caml/bigarray.h>

#include "cassandra.h"


void print_error(CassFuture* future) {
  const char* message;
  size_t message_length;
  cass_future_error_message(future, &message, &message_length);
  fprintf(stderr, "Error: %.*s", (int)message_length, message);
}

CAMLprim value match_enum(value rc, value future){
	CAMLparam2(rc, future);
	if (rc != CASS_OK) {
		print_error((CassFuture*)future);	
    	CAMLreturn(Val_int(0));//false
  }else{
    CAMLreturn (Val_int(1));//true
  }
 }
 
 CAMLprim value convert_to_ml(value val){
  CAMLparam1(val);
  CAMLreturn(Val_int(val));
 }

 CAMLprim value convert(value val){
 	CAMLparam1(val);
 	CAMLreturn(Int_val(val));
 }

 CAMLprim value convert_to_bool(value val){
  CAMLparam1(val);
  if (val == 1){
    CAMLreturn (Val_int(1));
  }else{
    CAMLreturn(Val_int(0));
  }
 }


CAMLprim value get_string_length(value val)
{
  CAMLparam1(val);
  const char* text;
  size_t text_length;
  
  cass_value_get_string((const CassValue*)val, &text, &text_length);
  int length = (int) text_length;
  CAMLreturn(Val_int(length));
}

CAMLprim value get_string_null(value val, value buf){
  
  CAMLparam2(val, buf);
  const char* text = "sample data";
  printf("\ntext value in c: %s", text);

  memcpy((char*)Caml_ba_data_val(buf), text, (long)12);
  
  printf("\ntext value in c: %s", text);
  printf("\nbuffer value in c: %s", buf);

  CAMLreturn (Val_unit);
}

//TRIAL 1


// CAMLprim value get_string_null(value val, value buf){
  
//   CAMLparam2(val, buf);
//   //CAMLlocal1(byt);
//   const char* text = "sample data";
//   size_t text_length;
  
//  // cass_value_get_string((const CassValue*)val, &text, &text_length);


//   int length = (int) text_length;
//   int c = 0;

//   char sub [length];
  
//   while (c < length) {
//       sub[c] = text[c];
//       c++;
//   }

//   memcpy((char*)Caml_ba_data_val(buf), sub, (long)12);
//   printf("\ntext value in c: %s", text);
//   printf("\nbuffer value in c: %s", buf);

//   printf("\nin c 4");
//   // CAMLreturn(Bytes_val(buf));
//   CAMLreturn (Val_unit);
// }

// caml_blit_string_to_bigstring(value val_buf1, value val_ofs1, value val_buf2, value val_ofs2, value val_len)
// {
//   memcpy((char*)Caml_ba_data_val(val_buf2) + Long_val(val_ofs2),
//          String_val(val_buf1) + Long_val(val_ofs1),
//          Long_val(val_len));
//   return Val_unit;
// }


 CAMLprim value get_string(value val){
  
  CAMLparam1(val);
  CAMLlocal1(var_value);
  const char* text;
  //const cass_byte_t* text;
  size_t text_length;
  
  cass_value_get_string((const CassValue*)val, &text, &text_length);
  //cass_value_get_bytes((const CassValue*)val, &text, &text_length);
  printf("\nget string in c: %s\n", text);
  int c = 0;
  int length = (int)text_length;
  printf("\nlength found in c = %d", length);
  char sub [length];
  
  while (c < length) {
      sub[c] = text[c];
      c++;
  }
  sub[c] = '\0';
    
  var_value = caml_copy_string(sub);
  printf("\nvar_value in c = %s\n", var_value);
  printf ("done in c");
  CAMLreturn(var_value);
  //CAMLreturn(sub);
 }
 
 CAMLprim value param_variant( value statement, value ind, value item, value size )
{
	CAMLparam4(statement, ind, item, size);
	//printf("\ninside param_variant: ");
	Tag_val(item);
	char* a = Field(item,0);
	int i =0;
    for (i = 0; a[i] != '\0'; ++i);
    //printf("length of item = %d", i);
    cass_statement_bind_string(statement, ind, Field(item,0));
//	cass_statement_bind_bytes(statement, ind, Field(item,0), size); //segmentation fault for more than 1000000
	printf("\nvalue = %s", Field(item,0));
	//printf("\nvalue = %s -- size of value in c = %d", Field(item,0), caml_string_length(Field(item,0)));
	
/*	switch (Tag_val(v))
        {
        case 0: printf(Field(v,0) ); break;
        
        default: caml_failwith("variant handling bug");
        }*/
    CAMLreturn(Val_unit);
}

CAMLprim value experiment (value str)
{
  CAMLparam1(str);
  CAMLlocal1(var_value);
  char* c = String_val (str);
  var_value = caml_copy_string(c);
  CAMLreturn(var_value);
  //CAMLreturn(str);

}