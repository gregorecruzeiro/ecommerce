<?php 

namespace Hcode\Model;

use \Hcode\DB\Sql;
use \Hcode\Model;

class Address extends Model {

const SESSION_ERROR = "AddressError";

	public static function setMsgError($msg)
	{
		$_SESSION[Address::SESSION_ERROR] = $msg;
	}

	public static function getMsgError()
	{
		$msg = (isset($_SESSION[Address::SESSION_ERROR])) ? $_SESSION[Address::SESSION_ERROR] : "";
		Address::clearMsgError();
		return $msg;
	}
	
	public static function clearMsgError()
	{
		$_SESSION[Address::SESSION_ERROR] = NULL;
	}

}
 ?>