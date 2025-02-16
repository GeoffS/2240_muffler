
module makeText(
	text="Hello World",
	textSize = 7,
	spacing = 1.2,
	font="Arial:style=Black",
	halign="center",
	valign="center")
{
	echo("makeText: text = ", text);
	echo("makeText: textSize = ", textSize);
	echo("makeText: font = ", font);
	echo("makeText: halign = ", halign);
	echo("makeText: valign = ", valign);
	linear_extrude(height = 2)
	{
	text(
		text=text,
		font=font,
		size=textSize,
		spacing=spacing,
		halign=halign,
		valign=valign);
	}
}