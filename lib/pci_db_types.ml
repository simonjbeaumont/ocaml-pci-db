module IdMap = Map.Make(Int64)
type id = IdMap.key

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
	subdevices : subdevice IdMap.t IdMap.t;
}

type vendor = {
	v_name : string;
	devices : device IdMap.t;
}

type t = {
	classes: classs IdMap.t;
	vendors: vendor IdMap.t;
}
