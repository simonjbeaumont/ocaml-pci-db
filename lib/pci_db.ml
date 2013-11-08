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

let pci_ids_path = "/usr/share/hwdata/pci.ids"

type t = Pci_db_types.t

let empty = { classes = IdMap.empty; vendors = IdMap.empty }

let add_class t c_id c = { t with classes = IdMap.add c_id c t.classes }
let get_class t c_id = IdMap.find c_id t.classes
let get_class_name t c_id = let c = get_class t c_id in c.c_name

let add_subclass t c_id sc_id sc =
	let c = get_class t c_id in
	add_class t c_id { c with subclasses = IdMap.add sc_id sc c.subclasses }
let get_subclass t c_id sc_id =
	let c = get_class t c_id in
	IdMap.find sc_id c.subclasses
let get_subclass_name t c_id sc_id =
	let sc = get_subclass t c_id sc_id in sc.sc_name

let add_progif t c_id sc_id p_id p =
	let sc = get_subclass t c_id sc_id in
	add_subclass t c_id sc_id { sc with progifs = IdMap.add p_id p sc.progifs}
let get_progif t c_id sc_id p_id =
	let sc = get_subclass t c_id sc_id in
	IdMap.find p_id sc.progifs
let get_progif_name t c_id sc_id p_id =
	let p = get_progif t c_id sc_id p_id in p.pi_name

let add_vendor t v_id v = { t with vendors = IdMap.add v_id v t.vendors }
let get_vendor t v_id = IdMap.find v_id t.vendors
let get_vendor_name t v_id = let v = get_vendor t v_id in v.v_name

let add_device t v_id d_id d =
	let v = get_vendor t v_id in
	add_vendor t v_id { v with devices = IdMap.add d_id d v.devices }
let get_device t v_id d_id =
	let v = get_vendor t v_id in
	IdMap.find d_id v.devices
let get_device_name t v_id d_id =
	let d = get_device t v_id d_id in d.d_name

let add_subdevice t v_id d_id sv_sd_id sd =
	let d = get_device t v_id d_id in
	add_device t v_id d_id { d with subdevices = IdMap.add sv_sd_id sd d.subdevices }
let get_subdevice t v_id d_id sv_sd_id =
	let d = get_device t v_id d_id in
	IdMap.find sv_sd_id d.subdevices
let get_subdevice_name t v_id d_id sv_id sd_id =
	let id = Id.SUBDEVICE_ID (sv_id, sd_id) in
	let sd = get_subdevice t v_id d_id id in sd.sd_name
let get_subdevice_names_by_id t v_id d_id sd_id =
	let d = get_device t v_id d_id in
	let matching =
		IdMap.filter (fun key sd ->
			match key with
			| Id.SUBDEVICE_ID (_, id) -> id = sd_id
			| _ -> false
		) d.subdevices
	in
	IdMap.fold (fun key sd names -> sd.sd_name :: names) matching []

let string_of_definition id name =
	Printf.sprintf "%s %s\n" (Id.to_string id) name

let to_string t =
	Printf.sprintf "%s%s"
		(IdMap.fold (fun id c acc ->
			Printf.sprintf "%s%s%s" acc
				(string_of_definition id c.c_name)
				(IdMap.fold (fun id sc acc ->
					Printf.sprintf "%s%s%s" acc
					(string_of_definition id sc.sc_name)
					(IdMap.fold (fun id pi acc ->
						string_of_definition id pi.pi_name
					) sc.progifs "")
				) c.subclasses "")
		) t.classes "")
		(IdMap.fold (fun id v acc ->
			Printf.sprintf "%s%s%s" acc
				(string_of_definition id v.v_name)
				(IdMap.fold (fun id d acc ->
					Printf.sprintf "%s%s%s" acc
					(string_of_definition id d.d_name)
					(IdMap.fold (fun id sd acc ->
						string_of_definition id sd.sd_name
					) d.subdevices "")
				) v.devices "")
		) t.vendors "")

let print t = print_string (to_string t)

let of_file path =
	let ic = open_in path in
	let lexbuf = Lexing.from_channel ic in
	Pci_ids_parser.file Pci_ids_lexer.token lexbuf
