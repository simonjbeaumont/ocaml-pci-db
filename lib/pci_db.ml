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
let find_class t c_id = IdMap.find c_id t.classes
let find_class_name t c_id = let c = find_class t c_id in c.c_name

let add_subclass t c_id sc_id sc =
	let c = find_class t c_id in
	add_class t c_id { c with subclasses = IdMap.add sc_id sc c.subclasses }
let find_subclass t c_id sc_id =
	let c = find_class t c_id in
	IdMap.find sc_id c.subclasses
let find_subclass_name t c_id sc_id =
	let sc = find_subclass t c_id sc_id in sc.sc_name

let add_progif t c_id sc_id p_id p =
	let sc = find_subclass t c_id sc_id in
	add_subclass t c_id sc_id { sc with progifs = IdMap.add p_id p sc.progifs}
let find_progif t c_id sc_id p_id =
	let sc = find_subclass t c_id sc_id in
	IdMap.find p_id sc.progifs
let find_progif_name t c_id sc_id p_id =
	let p = find_progif t c_id sc_id p_id in p.pi_name

let add_vendor t v_id v = { t with vendors = IdMap.add v_id v t.vendors }
let find_vendor t v_id = IdMap.find v_id t.vendors
let find_vendor_name t v_id = let v = find_vendor t v_id in v.v_name

let add_device t v_id d_id d =
	let v = find_vendor t v_id in
	add_vendor t v_id { v with devices = IdMap.add d_id d v.devices }
let find_device t v_id d_id =
	let v = find_vendor t v_id in
	IdMap.find d_id v.devices
let find_device_name t v_id d_id =
	let d = find_device t v_id d_id in d.d_name

let add_subdevice t v_id d_id sv_sd_id sd =
	let d = find_device t v_id d_id in
	add_device t v_id d_id { d with subdevices = IdMap.add sv_sd_id sd d.subdevices }
let find_subdevice t v_id d_id sv_id sd_id =
	let d = find_device t v_id d_id in
	IdMap.(find sd_id (find sv_id d.subdevices))
let find_subdevice_name t v_id d_id sv_id sd_id =
	let sd = find_subdevice t v_id d_id sv_id sd_id in sd.sd_name
let find_subdevice_names_by_id t v_id d_id sd_id =
	let d = find_device t v_id d_id in
	IdMap.fold (fun sv_id sd_map names ->
		try IdMap.find sd_id sd_map :: names
		with Not_found -> names
	) d.subdevices []

type merge_strategy = Ours | Theirs
let merge strategy t t' =
	(* FIXME: This needs to be recursive through the sub-maps *)
	let ours _ x y = match x with Some _ -> x | _ -> y
	and theirs _ x y = match y with Some _ -> y | _ -> x in
	let merge_f = match strategy with Ours -> ours | Theirs -> theirs in
	{ classes = IdMap.merge merge_f t.classes t'.classes;
	  vendors = IdMap.merge merge_f t.vendors t'.vendors; }

let string_of t =
	Printf.sprintf "%s%s"
		(IdMap.fold (fun id c acc ->
			Printf.sprintf "%s%s%s" acc
				(Printf.sprintf "%02Lx %s\n" id c.c_name)
				(IdMap.fold (fun id sc acc ->
					Printf.sprintf "%s%s%s" acc
					(Printf.sprintf "%02Lx %s\n" id sc.sc_name)
					(IdMap.fold (fun id pi acc ->
						Printf.sprintf "%02Lx %s\n" id pi.pi_name
					) sc.progifs "")
				) c.subclasses "")
		) t.classes "")
		(IdMap.fold (fun id v acc ->
			Printf.sprintf "%s%s%s" acc
				(Printf.sprintf "%04Lx %s\n" id v.v_name)
				(IdMap.fold (fun id d acc ->
					Printf.sprintf "%s%s%s" acc
					(Printf.sprintf "%04Lx %s\n" id d.d_name)
					(IdMap.fold (fun sv_id sd_map acc ->
						IdMap.fold (fun sd_id sd acc ->
							Printf.sprintf "%04Lx %04Lx %s\n" sv_id sd_id sd.sd_name
						) sd_map ""
					) d.subdevices "")
				) v.devices "")
		) t.vendors "")

let of_file path =
	let ic = open_in path in
	let lexbuf = Lexing.from_channel ic in
	Pci_ids_parser.file Pci_ids_lexer.token lexbuf
