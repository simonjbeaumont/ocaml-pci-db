module Id = struct
	type t =
		| CLASS_ID of int64
		| SUBCLASS_ID of int64
		| PROGIF_ID of int64
		| VENDOR_ID of int64
		| DEVICE_ID of int64
		| SUBDEVICE_ID of int64 * int64
	let compare = compare
end

module IdMap = Map.Make(Id)

type progif = {
	pi_name : string;
}

type subclass = {
	sc_name : string;
	progifs : progif IdMap.t;
}
type classs = {
	c_name : string;
	subclasses : subclass IdMap.t;
}

type subdevice = {
	sd_name : string;
}

type device = {
	d_name : string;
	subdevices : subdevice IdMap.t;
}

type vendor = {
	v_name : string;
	devices : device IdMap.t;
}

type t = {
	classes: classs IdMap.t;
	vendors: vendor IdMap.t;
}

