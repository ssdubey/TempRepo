#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module Store_module = Irmin_mem.AO (Irmin.Hash.SHA1) (Irmin.Contents.String);;
module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;

let config = Irmin_mem.config () ;;
let hashtable = Lwt_main.run @@ Store_module.v config ;;

let key = Lwt_main.run  (Store_module.add hashtable "emp3") ;;

let aw_t = Lwt_main.run @@ RW_module.v config ;;

let _ = RW_module.set aw_t "branch2" key ;;


(* let cstruct = Irmin.Hash.SHA1.to_raw key ;; *)
(* let cstruct = Irmin.Hash.SHA1.to_raw_int key ;;
let str = Cstruct.to_string cstruct ;;
let key2 = String.sub str 8 ((String.length str) - 8) ;; *)







(* #require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module Store_module = Irmin_mem.AO (Irmin.Hash.SHA1) (Irmin.Contents.String);;
module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Contents.String);;

let config = Irmin_mem.config () in
let hashtable = Lwt_main.run @@ Store_module.v config in
let key = Lwt_main.run  (Store_module.add hashtable "2 emp2 dept2") in 

let aw_t = Lwt_main.run @@ RW_module.v config in

(* let cstruct = Irmin.Type.encode_cstruct Store_module.key key in  *)
let cstruct = Irmin.Hash.SHA1.to_raw key in
let str = Cstruct.to_string cstruct in 
let key2 = String.sub str 8 ((String.length str) - 8) in

let _ = RW_module.set aw_t "master" key2 in () *)