shader_type sky;

/** The image to tile to the skybox. */
uniform sampler2D texture : source_color;
/** The horizontal size of each tile. */
uniform float scaleX = 1.0;
/** The vertical size of each tile.*/
uniform float scaleY = 1.0;
/** The speed at which each tile moves horizontally. */
uniform float offsetSpeedX = 0.05;
/** The speed at which each tile moves vertically. */
uniform float offsetSpeedY = 0.05;

void sky() {
	float timex = TIME * offsetSpeedX;
	float timey = TIME * offsetSpeedY;
	vec2 offset = vec2(1.0 * timex, 1.0 * timey);
	//vec2 uvpos = vec2(SKY_COORDS.x * offset.x, SKY_COORDS.y * offset.y);
	//vec2 uvsiz = vec2(scaleX, scaleY);
	vec2 uv = vec2(SKY_COORDS.x, SKY_COORDS.y);
	uv += offset;
	uv *= vec2(scaleX, scaleY);
	vec4 tex_color = texture(texture, uv);
	COLOR = tex_color.rgb;
}
