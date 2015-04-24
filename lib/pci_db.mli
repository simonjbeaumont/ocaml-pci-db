(*
 * Copyright (C) Citrix Systems Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *)

open Pci_db_types

type t

val pci_ids_path : string

val find_class_name : t -> id -> string
val find_subclass_name : t -> id -> id -> string
val find_vendor_name : t -> id -> string
val find_device_name : t -> id -> id -> string
val find_subdevice_name : t -> id -> id -> int64 -> int64 -> string

type merge_strategy = Ours | Theirs
val merge : merge_strategy -> t -> t -> t

val string_of : t -> string

val of_file : string -> t
