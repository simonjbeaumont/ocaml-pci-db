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

type t

type class_id = int64
type subclass_id = int64
type vendor_id = int64
type subvendor_id = int64
type device_id = int64
type subdevice_id = int64

val pci_ids_path : string

val get_class_name : t -> class_id -> string
val get_subclass_name : t -> class_id -> subclass_id -> string
val get_vendor_name : t -> vendor_id -> string
val get_device_name : t -> vendor_id -> device_id -> string
val get_subdevice_name : t -> vendor_id -> device_id -> subvendor_id -> subdevice_id -> string

val print : t -> unit

val of_file : string -> t
