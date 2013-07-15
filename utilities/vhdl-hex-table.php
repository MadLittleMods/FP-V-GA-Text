<?php

// Author: Eric (MLM)
// Generates an array table of all characters that VHDL supports
//
// "character'val(16#20#)" notation is equivalent to 20 in base 16 (hex) which is the space character

error_reporting(E_ALL);

header('Content-Type: text/html; charset=iso-8859-1');

$start = 0;
$end = 255; // 127 or 255

$omitArray = array_merge(range(0, 31));
$characterNotationArray = array_merge(range(127, 159)); 

$customCharacterDescriptionArray = array(
	0 => 'NULL',
	9 => 'HT Tab',
	10 => 'LF',
	13 => 'CR',
	32 => 'SP Space',
	127 => 'DEL',
	129 => 'HOP	High Octet Preset',
	143 => 'SS3	Single Shift 3',
	144 => 'DCS	Device Control String',
	157 => 'OSC	Operating System Command',
	160 => 'NBSP Space',
);


echo '<pre>';
echo '-- Char => Addr' . "\t" . '-- ' . 'Decimal : Hex' . "\n";

for ($i = $start; $i <= $end; $i++)
{

	echo 'character\'val(16#' . str_pad(dechex($i), 2, "0", STR_PAD_LEFT) . '#)' . ' => "' . str_pad(decbin($i), 8, "0", STR_PAD_LEFT) . '",' . "\t" . '-- ' . (!array_key_exists($i, $customCharacterDescriptionArray) ? chr($i) : $customCharacterDescriptionArray[$i])  . ' : ' . $i . ' : x' . str_pad(dechex($i), 2, "0", STR_PAD_LEFT) . "\n";
	
}
echo '</pre>';