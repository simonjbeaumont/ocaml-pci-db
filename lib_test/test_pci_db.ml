open OUnit
open Pci_db_types

(* Utility functions *)

let rec foldi n f acc =
	if n = 0 then acc else foldi (pred n) f (f acc)

let id x = x

let rec prefix x ys acc =
	match ys with
	| [] -> acc
	| y::ys -> prefix x ys ((x,y) :: acc)

let rec all_pairs xs ys acc =
	match xs with
	| [] -> acc
	| x::xs -> all_pairs xs ys (prefix x ys acc)

(* Tests *)

let with_test_db (f: Pci_db.t -> unit) =
	let pci_db = Pci_db.of_file "./mock-pci.ids" in
	f pci_db

let test_of_file _ =
	with_test_db (fun _ -> ())

let test_find_vendor_name _ =
	with_test_db (fun db ->
		List.iter
			(fun (vendor_id, expected_name) ->
				assert_equal ~printer:id expected_name
					(Pci_db.find_vendor_name db vendor_id))
			[
				(1, "SimpleVendorName1");
				(2, "SimpleVendorName2");
				(3, "SimpleVendorName3");
				(4, "SimpleVendorName4");
				(5, "VendorName with whitespace");
				(6, "VendorName with punctuation :;<=>?@[\\]^_`{|}~`/");
			];
		assert_raises ~msg:"Lookup with non-existent id" Not_found
			(fun () -> Pci_db.find_vendor_name db 7)
	)

let test_find_device_name _ =
	with_test_db (fun db ->
		List.iter
			(fun (vendor_id, dev_id, expected_name) ->
				assert_equal ~printer:id expected_name
					(Pci_db.find_device_name db vendor_id
						dev_id))
			[
				(2, 0x1, "SimpleDeviceName-2-1");
				(3, 0x1, "SimpleDeviceName-3-1");
				(3, 0x2, "SimpleDeviceName-3-2");
				(3, 0x3, "SimpleDeviceName-3-3");
				(5, 0xa, "DeviceName with whitespace and hex ID");
			];
		assert_raises ~msg:"Lookup with non-existent id" Not_found
			(fun () -> Pci_db.find_device_name db 2 4)
	)

let test_string_of _ =
	with_test_db (fun db ->
		let db_str = Pci_db.string_of db in
		let rec count_lines s acc =
			try 
				count_lines (String.sub s 1 (String.length s - 1))
					(if s.[0] = '\n' then succ acc else acc)
			with Invalid_argument _ -> acc
		in
		print_string db_str;
		"Check expected items in parsed db" @? (count_lines db_str 0 = 21)
	)

let _ =
	let suite = "pci_db" >:::
		[
			"test_of_file" >:: test_of_file;
			"test_string_of" >:: test_string_of;
			"test_find_vendor_name" >:: test_find_vendor_name;
			"test_find_device_name" >:: test_find_device_name;
		]
	in
	run_test_tt ~verbose:true suite
