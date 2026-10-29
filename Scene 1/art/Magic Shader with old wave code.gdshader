shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D noise_texture_1 : repeat_enable;
uniform sampler2D noise_texture_2 : repeat_enable;
varying vec2 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec4 oldColor = texture(TEXTURE, UV);
	vec4 noise1 = texture(noise_texture_1, world_position / 180.0);
	vec4 noise2 = texture(noise_texture_2, world_position / 180.0);
	
	float shaderStrength = (0.0 - oldColor.r) + 1.0;
	
	vec2 distortedUV = SCREEN_UV;
	distortedUV.y += sin((distortedUV.y * 50.0) + TIME * 5.0) * 0.002 * shaderStrength;
	distortedUV.x += sin((distortedUV.x * 50.0) + TIME * 5.0) * 0.002 * shaderStrength;
	distortedUV.y += sin((distortedUV.x * 50.0) + TIME * 5.0) * 0.002 * shaderStrength;
	distortedUV.x += sin((distortedUV.y * 50.0) + TIME * 5.0) * 0.002 * shaderStrength;
	
    vec3 newColor = textureLod(screen_texture, mix(distortedUV, SCREEN_UV, noise1.r), 0.0).rgb;
	float distanceCenter = sqrt(pow(world_position.x, 2.0) + pow(world_position.y, 2.0));
	
	//if (mod((TIME * 2.0) - (distanceCenter / 70.0), PI * 2.0) > PI / 2.0){
		newColor.gb *= mix(1.0, noise1.r, shaderStrength);
	//}
	//newColor.gb *= mix(1.0, noise2.r, shaderStrength);
	
	/*if (sin((TIME * 2.0) - (distanceCenter / 70.0)) > 0.999){
		newColor.rg = vec2(noise1.r * 2.0, noise1.r * 2.0);
	}*/

    COLOR.rgb = newColor;
}