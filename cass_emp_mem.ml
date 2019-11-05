for Irmin master

(*add in ao*)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;



module Store_module = Irmin_mem.Append_only (Irmin.Contents.String) (Irmin.Contents.String);;
let conf = Irmin_mem.config ();;
let session = Lwt_main.run @@ Store_module.v conf;;
let bat = Store_module.batch session (fun sm -> Store_module.add sm "key" "value");;

(*-----------------------------------------------------------*)
(* set in aw *) 

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;

let config = Irmin_mem.config () ;;

let aw_t = Lwt_main.run @@ RW_module.v config ;;

let _ = RW_module.set aw_t "master" "key" ;;

(*-----------------------------------------------------------*)
(* test n set in aw *) 

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;

let config = Irmin_mem.config () ;;

let aw_t = Lwt_main.run @@ RW_module.v config ;;

let q = Lwt_main.run @@ RW_module.test_and_set aw_t "master" ~test:(Some "key") ~set:(Some "value");;


(*-----------------------------------------------------------*)
(* find in aw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.find aw_t "master";;

(* match findval with 
  | Some x -> (
        let valStr = Irmin.Type.to_string Irmin.Type.string x in 
            print_string ("\nResult = " ^ valStr);
	        print_string ("\nLength ="); print_int(String.length valStr);
      )
  | _ -> () *)

(*-----------------------------------------------------------*)
(*  mem in rw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.mem aw_t "master";;

(*-----------------------------------------------------------*)
(* list in aw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let lst = Lwt_main.run @@ RW_module.list aw_t;;

(* List.fold_left (fun () -> 
	(Irmin.Type.to_string (Irmin.Contents.String.t);print_string)) () lst;; *)

(*-----------------------------------------------------------*)
(* remove in aw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let _ = RW_module.remove aw_t "master1";;

-----------------------------------------------------------------------------
for Irmin 1.3.3.
(* set in ao *) 

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

let key = Lwt_main.run  (Store_module.add hashtable "emp6") ;;

let aw_t = Lwt_main.run @@ RW_module.v config ;;

let _ = RW_module.set aw_t "master" key ;;


(*-----------------------------------------------------------*)
(* find in rw *)

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.find aw_t "master";;

match findval with 
  | Some x -> (
        let valcs = Irmin.Type.encode_cstruct Irmin.Hash.SHA1.t x in 
        let valStr = Cstruct.to_string valcs in 
	        print_string ("\nResult = " ^ valStr);
	        print_string ("\nLength ="); print_int(String.length valStr);
      )
  | _ -> ()

(*-----------------------------------------------------------*)
(* test_and_set in rw which involves set in ao and find in rw *)

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
let key1 = Lwt_main.run  (Store_module.add hashtable "emp1") ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let _ = RW_module.set aw_t "master" key1 ;;

RW_module.test_and_set aw_t "master" ~test:(Some key1) ~set:(Some key1);;

(*-----------------------------------------------------------*)
(* list in rw *)

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let _ = RW_module.list aw_t;;

(*-----------------------------------------------------------*)
(*  mem in rw *)

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.mem aw_t "master";;

(*-----------------------------------------------------------*)
Irmin KV eg
#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;
#require "checkseum.ocaml";;
#require "irmin-unix";;

Creating a repo
module Mem_kvStore = Irmin_mem.KV(Irmin.Contents.String);;      (*creating the module with the set of functions*)
let t = Irmin_mem.config ();;   (*configuration values related to irmin_mem store*)   (*val t : Irmin.config = <abstr>*)
let repo = Lwt_main.run @@ Mem_kvStore.Repo.v t;;   (*kvrepo is like .git, which is initialized with the configurations specified in t. *)  (*val repo : Mem_kvStore.repo = <abstr>*)
let branch_master = Lwt_main.run @@ Mem_kvStore.master repo;;   (*KVStore.t*) (*creating master branch in the repo. It will be pointed and used by the string name "branch_master"*)  (*val branch_master : Mem_kvStore.t = <abstr>*)
Mem_kvStore.Branch.list repo;;  (*printing the list of all branches yet, result is empty*)
(*Mem_kvStore.set_exn ~info:(Irmin_unix.info "entering data into master") branch_master ["foor";"barr"] "testing 123";;   (*setting some key and value in master branch*)*)
Mem_kvStore.set_exn ~info:(fun () -> Irmin.Info.empty) branch_master ["foor";"barr"] "testing 123";;
Mem_kvStore.get branch_master ["foor";"barr"];;   (*printing "testing 123"*)
Mem_kvStore.Branch.list repo;;  (*printing the list of all branches yet, master is returned*)
Mem_kvStore.clone branch_master "branch1" ;; (*clones the master branch into a new branch called as "branch1" *)  (*Mem_kvStore.t = <abstr>*)
Mem_kvStore.Branch.list repo;;  (*printing the list of all branches yet, master and branch1 are returned*)
Mem_kvStore.get branch1 ["foor";"barr"];; (*branch1 is the name of the branch but a pointer is needed to access it.*)
let cloned_branch = Lwt_main.run @@ Mem_kvStore.clone branch_master "branch1" ;;  (*val cloned_branch : Mem_kvStore.t = <abstr>*)
Mem_kvStore.Branch.list repo;;  (*verifying the effect of above command, nothing changes*)
Mem_kvStore.get cloned_branch ["foor";"barr"];; (*printing output same as master branch*)
Mem_kvStore.set_exn ~info:(Irmin_unix.info "update1 to master") branch_master ["key_in_master";] "master value";;
Mem_kvStore.set_exn ~info:(Irmin_unix.info "update1 to branch1") cloned_branch ["key_in_clone";] "clone value";;
Mem_kvStore.get cloned_branch ["key_in_clone"];; (*prints "clone value"*)
Mem_kvStore.get cloned_branch ["key_in_master"];; (*Exception: (Invalid_argument "Irmin.Tree.get: /key_in_master not found")*)
Mem_kvStore.get branch_master ["key_in_clone"];;  (*Exception: (Invalid_argument "Irmin.Tree.get: /key_in_clone not found")*)
Mem_kvStore.get branch_master ["key_in_master"];; (*prints "master value"*)
Mem_kvStore.Branch.list repo;;  (*checking the list of branches before operating on them*)
Mem_kvStore.merge_into ~info:(Irmin_unix.info "merging branch1 into master") cloned_branch ~into:branch_master;; (*only branch pointers can be used for any operations*)
Mem_kvStore.Branch.list repo;; (*still prints two branches*)
(*is it possible to get the list of keys in a branch*)
(*print clones data from master*)
Mem_kvStore.get branch_master ["key_in_clone"];;  (*prints "clone value"*)
Mem_kvStore.get cloned_branch ["key_in_master"];;  (*still gives error like earlier*)
(*create conflict and merge*)
(*whole tree in the repo has to be committed. So get the tree first*)
let tree = Lwt_main.run @@ Mem_kvStore.tree branch_master;;  (*val tree : Mem_kvStore.tree = `Node <abstr>*)
let commit = Lwt_main.run @@ Mem_kvStore.Commit.v repo ~info:(Irmin.Info.empty) ~parents:[] tree;;  (*val commit : Mem_kvStore.commit = <abstr>*)  (*kv1 from the test code*)
-----
Mem_kvStore.Branch.set repo "foo" commit;;
Mem_kvStore.Branch.find repo "foo";; (*Mem_kvStore.commit option = Some <abstr>*)
Mem_kvStore.Branch.list repo;;
-----
------
let ins = Lwt_main.run @@ Mem_kvStore.get_tree branch_master [];;
Mem_kvStore.Tree.inspect ins;;
------

Mem_kvStore.Branch.get repo "master";; (*I think its returning hte pointer to the brnach*)
Mem_kvStore.Branch.mem repo "branch1";; (*checks if the branch is the part of the repo*) (*returns true*)

Mem_kvStore.Branch.set repo "set1" commit;; (*It is checking out a new branch named "set1" which is a copy of committed branch*)(*returns unit*)
Mem_kvStore.Branch.list repo;;  (*string list = ["set1"; "master"; "branch1"]*)
let branch_set1 = Lwt_main.run @@ Mem_kvStore.Branch.get repo "set1";;
Mem_kvStore.get branch_set1 ["key_in_clone"];;
Mem_kvStore.get cloned_branch ["key_in_master"];;


---------------------------------------
test_stores

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


let () = Random.self_init ()
let random_char () = char_of_int (Random.int 256)
let random_string n = String.init n (fun _i -> random_char ())
let long_random_string = random_string (* 1024_000 *) 10
let v1 = long_random_string;;

let v2 = "";;

module S = Irmin_mem.KV(Irmin.Contents.String);;      (*creating the module with the set of functions*)
let t = Irmin_mem.config ();;   (*configuration values related to irmin_mem store*)   (*val t : Irmin.config = <abstr>*)
let repo = Lwt_main.run @@ S.Repo.v t;;

let t = Lwt_main.run @@ S.master repo;;
S.set_exn t ~info:(fun () -> Irmin.Info.empty) [ "a"; "b" ] v1 
S.mem t [ "a"; "b" ] ;; (* Alcotest.(check bool) "mem0" true b0; *)
let t = Lwt_main.run @@ S.clone ~src:t ~dst:"test";;
S.mem t [ "a"; "b" ];;(*   Alcotest.(check bool) "mem1" true b1; *)
S.mem t [ "a" ] ;;(*     Alcotest.(check bool) "mem2" false b2; *)
S.find t [ "a"; "b" ] (*   check_val "v1.1" (Some v1) v1'; *)
let r1 = Lwt_main.run @@ S.Head.get t;;
let t = S.clone ~src:t ~dst:"test";;
S.set_exn t ~info:(fun () -> Irmin.Info.empty) [ "a"; "c" ] v2 ;;
S.mem t [ "a"; "b" ] ;;(*  Alcotest.(check bool) "mem3" true b1; *)
S.mem t [ "a" ] ;;(*     Alcotest.(check bool) "mem4" false b2; *)
S.find t [ "a"; "b" ] ;;(*     check_val "v1.1" (Some v1) v1'; *)
S.mem t [ "a"; "c" ] ;;(*    Alcotest.(check bool) "mem5" true b1; *)

------------------------------
test trees

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module Mem_kvStore = Irmin_mem.KV(Irmin.Contents.String);;      (*creating the module with the set of functions*)
let t = Irmin_mem.config ();;   (*configuration values related to irmin_mem store*)   (*val t : Irmin.config = <abstr>*)
let repo = Lwt_main.run @@ Mem_kvStore.Repo.v t;; 
let v1 = Mem_kvStore.Tree.empty;;
let v1 = Lwt_main.run @@ Mem_kvStore.Tree.add v1 [ "foo"; "toto" ] "rand1";;
let v1 = Lwt_main.run @@ Mem_kvStore.Tree.add v1 [ "foo"; "bar"; "toto" ] "rand2";;
Mem_kvStore.Tree.get v1 [ "foo"; "bar"; "toto" ];;
Mem_kvStore.Tree.get v1 [ "foo"; "toto" ];;

-------------------
test merge

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module Mem_kvStore = Irmin_mem.KV(Irmin.Contents.String);; 
let t = Irmin_mem.config ();; 
let repo = Lwt_main.run @@ Mem_kvStore.Repo.v t;; 
let t1 = Lwt_main.run @@ Mem_kvStore.master repo;;
let v1 = "X1";;
let v2 = "X2" ;;
let v3 = "X3" ;;
Mem_kvStore.set_exn ~info:(fun () -> Irmin.Info.empty) t1 [ "a"; "b"; "a" ] v1;;
Mem_kvStore.set_exn ~info:(fun () -> Irmin.Info.empty) t1 [ "a"; "b"; "b" ] v2;;
Mem_kvStore.set_exn ~info:(fun () -> Irmin.Info.empty) t1 [ "a"; "b"; "c" ] v3;;
let test = "test" ;;
let t2 = Lwt_main.run @@ Mem_kvStore.clone ~src:t1 ~dst:test ;;
Mem_kvStore.set_exn ~info:(fun () -> Irmin.Info.empty) t1 [ "a"; "b"; "b" ] v1;;
Mem_kvStore.set_exn ~info:(fun () -> Irmin.Info.empty) t1 [ "a"; "b"; "b" ] v3;;
Mem_kvStore.set_exn ~info:(fun () -> Irmin.Info.empty) t2 [ "a"; "b"; "c" ] v1;;

Mem_kvStore.merge_into ~info:(fun () -> Irmin.Info.empty) t2 ~into:t1;;

Mem_kvStore.get t1 [ "a"; "b"; "c" ];;
Mem_kvStore.get t2 [ "a"; "b"; "b" ];;
Mem_kvStore.get t1 [ "a"; "b"; "b" ] ;;

Rough

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;
#require "checkseum.ocaml";;
#require "irmin-unix";;

(*create a module from KV store (what does kvstore do?)  *)
module KVStore = Irmin_mem.KV(Irmin.Contents.String);;
let t = Irmin_mem.config ();;   (*configuration values related to irmin_mem store*)
let kvrepo = Lwt_main.run @@ KVStore.Repo.v t;;   (*kvrepo is like .git, which is initialized with the configurations specified in t. *)
let root = Lwt_main.run @@ KVStore.empty kvrepo;;   (*making .git empty so that it behaves like the root of the tree structure we will be making*)
let tree = KVStore.tree root;;

(*list of branches*)
KVStore.Repo.branches kvrepo;;
let branch1 = Lwt_main.run @@ KVStore.master kvrepo;;
KVStore.get branch1 [ "foo"; "bar" ];;   (*branch1*)

let info fmt = Irmin_unix.info ~author:"ewr" fmt;;
KVStore.set_exn ~info:(info "updating") root [ "foo"; "bar" ] "testing 123";;
let g = Lwt_main.run @@ KVStore.get root [ "foo"; "bar" ];;
-----------------------------------------------------------------------------------------------

module MemStore = Irmin_mem.KV(Irmin.Contents.String);;
let config = Irmin_mem.config ();;
let memrepo = Lwt_main.run @@ MemStore.Repo.v config;;    (*MemStore.repo*)
let branch1 = Lwt_main.run @@ MemStore.master memrepo;;   (*MemStore.t*)
let branch2 = Lwt_main.run @@ MemStore.master memrepo;;
MemStore.set_exn  ~info:(Irmin_unix.info "updating branch1") branch1 ["foor";"barr"] "testing 123";;
MemStore.set_exn  ~info:(info "updating branch1") branch1 ["foor";"barr"] "testing 123";;


MemStore.clone branch1 "cloning_again2" ;;
MemStore.Branch.list memrepo;;
MemStore.merge_into ~info:(Irmin_unix.info "merging 1 into 2") branch1 ~into:branch2;;
MemStore.find branch2 ["foo5";"bar5"] ;;

let commitid = MemStore.commit_t memrepo;;  (*MemStore.commit Irmin.Type.ty*)

MemStore.Branch.set;;
- : MemStore.repo -> string -> MemStore.commit -> unit Lwt.t = <fun>

let tree = Lwt_main.run @@ MemStore.tree branch1;;
let commit = Lwt_main.run @@ MemStore.Commit.v memrepo ~info:(Irmin.Info.empty) ~parents:[] tree;;
MemStore.Branch.set memrepo "set1" commit;;
MemStore.Branch.list memrepo;;




