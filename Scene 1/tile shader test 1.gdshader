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
	
	float mask = ((0.0 - oldColor.r) + 1.0);
	
	vec2 distortedUV = SCREEN_UV;
	/*distortedUV.y += sin((distortedUV.y * 50.0) + TIME * 5.0) * 0.002 * mask;
	distortedUV.x += sin((distortedUV.x * 50.0) + TIME * 5.0) * 0.002 * mask;
	distortedUV.y += sin((distortedUV.x * 50.0) + TIME * 5.0) * 0.002 * mask;
	distortedUV.x += sin((distortedUV.y * 50.0) + TIME * 5.0) * 0.002 * mask;*/
	
	distortedUV.y += ((noise2.r * 2.0) - 1.0) * 0.005 * mask;
	distortedUV.x += ((noise2.g * 2.0) - 1.0) * 0.005 * mask;
	
    vec3 newColor = textureLod(screen_texture, mix(distortedUV, SCREEN_UV, noise1.r), 0.0).rgb;
	float distanceCenter = sqrt(pow(world_position.x, 2.0) + pow(world_position.y, 2.0));
	float magicOverlay = noise1.r * mask;
	
	vec3 primaryColor = vec3(0.0, 0.0, 0.7);
	vec3 secondaryColor = vec3(0.0, 0.0, 0.0);
	float colourTransttion = 0.2;
	
	float secondaryTransition = max(magicOverlay - colourTransttion, 0);
	vec3 magicFinalColor = mix(primaryColor, secondaryColor, secondaryTransition * 10.0 / (10.0 - colourTransttion));
	
	float shaderStrength = 1.0;
	
	newColor = mix(newColor, magicFinalColor, smoothstep(0, 1, magicOverlay * shaderStrength * 1.1));

    COLOR.rgb = newColor;
}