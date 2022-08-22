Procedural surface shader demo.
	Thank you for downloading this package, whatever reason you did.
	Contains one shader, "Lumpy".
	
	In the included demo scene, 
		double click one of the "Focus Me" objects to be moved nearby to a given set of objects.
	

Included shader, "Lumpy" is a voroni-cell noise with a number of properties:
	
	Variant Toggles:
		These toggles change core features of the shader, 
			and can drastically change the way the surface looks,
			and how the surface performs (both rendering speed and how it changes if the object moves)
	
		"Use Worley Noise" 
			Toggles the shader between using "Worley" and "Manhattan" distances
			Enabling it: 
				Generator uses "Worley" distance, creates cells with lines at any angle
			Disabling it:
				Generator uses "Manhattan" distance, creates cells with lines at 90/45 degree angles
				
		"Use Worldspace Position"
			Toggles the shader from using the position of the pixel in world/local space.
			Enabling it:
				-Makes it easy for multiple objects to share the same material,
					with the seam between the objects typically being invisible, 
					so long as they line up.
				-Also makes it so that if the object moves/rotates, the texture does too,
					so make sure that objects using "worldspace" are static (don't move/rotate)
			Disabling it:
				-Makes it so that multiple objects with the same mesh/material
					will look identical.
				-Also makes it so that the object can move without the texture moving
					-With the exception of skinned/animated meshes
			Remarks:
				It's not likely that material settings can be easily shared between variants
				with this option enabled/disabled. Various texture scales may need to be changed.
		
		"Fancy Parallax"
			Toggles the parallax mode used by the shader.
			Enabling it:
				-Shader uses a short raycast in a depthfield for parallax. 
					Can be slow, depending on how deep the raycast needs to go on average.
				-Also makes the surface more consistant, and only in a smaller depth range,
					due to how the raycast works
			Disabling it:
				-Shader uses a single sample of a depthfield for parallax. 
					Much faster, especially on older cards.
				-Also makes the surface less consistant, and takes values in a wider depth range.
					Can be used to create some interesting highly warped looking glassy surfaces.
			Remarks:
				Having this enabled typicaclly leads to a much more pleasing look for the surface
				It's recommended to have a quality option to enable/disable this feature,
					to make sure that the game can still run reasonably well 
					on older cards that _can_ support it, but are slow.
				Also, if "Parallax amount" is set to 0, to disable this option.
			
	Colors:
		Controls for the colors used for the surface.
		
		"Primary Color"
			Color of the 'cells'
		"Secondary Color"
			Color of the 'detail texture'
	
	Surface Property:
		Controls for the PBR details of the surface. 
		
		"Polish"
			Amount of "Glossiness" and "Metallic" applyed based on the "Height"
		"Glossiness"
			Unity 5 Standard PBR property. Controls how much light the surface reflects.
		"Metallic"
			Unity 5 Standard PBR property. Controls how much the surface color is obscured by reflections.
	
	Lumpyness:
		Controls for the Generated 'cells'
		
		"Voroni Composition"
			This controls the general look&feel of the cell noise that is generated.
			
			The voroni-cell noise is based off of the distance from any point to a set of nearby points.
			This vector controls how the 3 closest point values affect the "value" of that pixel.
				X - multiplier of distance to 1st closest point
				Y - multiplier of distance to 2nd closest point
				Z - multiplier of distance to 3rd closest point
				W - multiplier ontop of (x,y,z)
				
			Some ways to set this up:
				-Rolling Lumps
					-Set X, Y, Z to add up to 0 (or close to) (ex, 1, -.5, -.5)
					-Use W to change the 'height' as desired
				-Stonelike
					-Set X, Y, Z to add up to 2 (or close to) (ex, 1.02, .25, .67)
					-Use a W around .5
			
			Experiment with the settings, this is a good setting to play with!
		
		"Voroni Scale"
			Controls the voroni-cell texture scale.
				Large values make more cells in the same area
				Smaller values make fewer cells in the same area
			
	Bump Texture:
		Controls for the Generated "Bump" texture.
		
		"Bump Octaves"
			Controls the number of 'octaves' of noise that are compiled for the 'bump' texture.
			Higher values make a more complex texture, and only slightly worse performance.
			Lower values make a simpler texture, and only slightly better performance.
		"Bump Persistence"
			Controls how much power the 'deeper octaves' of noise have on the 'bump' texture.
			Higher values make a rougher texture.
			Lower values make a simpler texture.
		"Bump Spread"
			Controls the base scale of the bump texture. 
			Larger values make more smaller 'bumps' in the same area.
			Smaller values make fewer large 'bumps' in the same area.
		"Bump Amount"
			Controls the intensity of the bump texture.
			Larger values make a less smooth- looking surface.
			Smaller values make a smoother looking surface.
		
	Noise Settings:
		General Controls for texture generation
		
		"Seed"
			Value used in the pseudo random number generator.
			Changing this can superficially change the look of the surface.
			Used by pretty much all layers of textures.
			Just needs to be a decently high value. Suggested range (1,000 - 100,000)
			Sometimes lower values (< 1,000) can work, but it can depend on other settings.
		"Octaves"
			Controls the number of "octaves" of noise applied for textures.
			Overrided by some textures (like "bump")
			Higher values make a more complex texture, and only slightly worse performance.
			Lower values make a simpler texture, and only slightly better performance.
		"Persistence"
			Overrided by some textures (like "bump")
			Controls how much power the 'deeper octaves' of noise have over textures.
			Higher values make a rougher texture.
			Lower values make a simpler texture.
		"Scale"
			Controls the base scale of generated textures
			Overrided by some textures (like "bump")
			Higher values make a more busy texture
			Lower values make a more sublte texture
			
	Parallax Settings
		Controls for the parallax effect.
		This effect makes the surface seem to have depth, 
			even if it's applied to flat polygons.
		
		"Parallax Amount"
			Controls the maximum depth of the surface.
			May need to be anywhere between 0 and 1000, depending on the scale of the surface.
			Larger values make a bigger parallax effect (more percieved depth)
			Smaller values make the surface seem more flat.
			
		"Depth Layers"
			Controls the number of layers used during the "Fancy Parallax" raycast.
			More layers mean the surface will be more detailed, but also can SEVERLY affect performance.
			Just like the "Fancy Parallax" toggle itself, 
				It may be a good idea to include a user-controllable setting for this parameter,
				to allow users to reduce the number of layers to improve performance.
			
	Texture Offsets
		"Noise Offset"
			General offset used to offset the texture as a whole.
			Final offset is (x, y, z) * w, as stated on the label.
			This can be used to pan the texture across a surface for a desired look.
			It can also be used to line up the textures 
				on objects that do not have "Use Worldspace Position" enabled.
				
			Could also be used to move textures to 'resonable' positions:
				Worldspace textured objects at insane positions (0, 100000, 0)
				
		
		
	
	
.
















































			
	