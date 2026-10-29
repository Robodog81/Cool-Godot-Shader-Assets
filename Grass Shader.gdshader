shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float brightness = 0.8;
uniform float contrast = 2.0;
uniform float saturation = 10.0;

void fragment() {
    vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);
	vec2 newUV = UV;
	
	vec4 sprite = texture(TEXTURE, newUV);
	
	sprite = c;
	float flipY = abs(newUV.y - 1.0);
	float sinVal = (sin(TIME) + 1.0) / 2.0;
	float sinVal2 = abs(((sin(TIME) + 1.0) / 2.0) - 1.0);
	newUV.x += ((flipY * flipY) * sinVal2 * 0.7);
	
	float shrinkVal = 1.0 + (sinVal2 * 2.0);
	
	if (newUV.y > 
	
	(sin(10.0 + newUV.x * 140.0) + shrinkVal) / (shrinkVal + 1.0))
	
	{
		sprite.rgb = vec3(0.1, min(flipY + 0.1, 0.6), 0.1);
	}

    c.rgb = mix(vec3(0.0), c.rgb, brightness);
    c.rgb = mix(vec3(0.5), c.rgb, contrast);
    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);

    COLOR = sprite;
}