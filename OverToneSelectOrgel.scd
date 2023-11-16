
// Declaration of Synths
// Declsration of Sawthoth Synth
(
SynthDef(\Sawthoth, { |out, freq|
    Out.ar(out,
		Saw.ar(freq, 0.2);
    )
}).add;
)

// Test for Sawthoth Synth
// x = Synth(\Sawthoth, [out: 0, freq: 840 ]);

// Declaration of Square Synth
(
SynthDef(\Square, { |out, freq|
    Out.ar(out,
		Pulse.ar(freq, 0.2);
    )
}).add;
)

// Test for Square Synth
// x = Synth(\Square, [out: 0, freq: 220 ]);

// Declaration for Memory Registers
(
// Square Synth Registers
// Declaration of Memory for Tunes / Frequencies
~square_tunes = Array.new();
// Declaration of Memory for Synth Instances
~square_synths = Array.new();

// Sawthoth Synth Registers
// Declaration of Memory for Tunes / Frequencies
~sawthoth_tunes = Array.new();
// Declaration of Memory for Synth Instances
~sawthoth_synths = Array.new();
)

/**
// Ckeck Content of Synth Registers
// Content of Square Registers
~square_tunes;
~square_synths;

// Content of Sawthoth Registers
~sawthoth_tunes;
~sawthoth_synths;
**/

// Function to create a Square Synth Instance
(
~setSquare = { arg freq; // Input for choosen Frequency
	// Call Square Synth
	x = Synth(\Square, [out: 0, freq: freq ]);
	// Save Frequencie in to Register
	~square_tunes = ~square_tunes.add(freq);
	// Save Synth Instance to Register
	~square_synths = ~square_synths.add(x);
};
)

// Function to create a Sawthoth Synth Instance
(
~setSawthoth = { arg freq; // Input for Choosen Frequency
	// Call Sawthoth Synth
	x = Synth(\Sawthoth, [out: 0, freq: freq ]);
	// Save Frequency in to Register
	~sawthoth_tunes = ~sawthoth_tunes.add(freq);
	// Save Synth Instance to Register
	~sawthoth_synths = ~sawthoth_synths.add(x);
};
)

// Function to Calculate new Frequency from Given aktiv Sound-Set
(
~calcTune = {
	arg v; // Paramter for Type of Calculation
	// True is Square False is Sawthoth Mode
	var n, m, x, y, o; // Memory Declarations for Temorary Variables
	// o is Number of Overtone
	// m is Size of Selected Synth Register
	// n is Old Frequency
	// x is Temporary pre new Frequency
	// y is resulted new Frequency

	// Choosing of old Overtone
	o = 6.bilinrand.abs;

	// Probility Choosing of Reading from Square or Sawthoth Registers
	if([false, true].choose)
	{
		// Estimate Size of Square Register
		m = ~square_tunes.size;
		// If Register is not Empty
		if(m>0)
		{
			// Select Old Frequency
			n = ~square_tunes[m.rand];
			// Callculate a selected Over-Tone for the Selected Frequency
			x = n * ( 1 + ((o+1)*2));
		}
		// If Register is Empty choose a new Random Frequency
		{ x = rrand(40, 10000); }
	}
	{
		// Estimate Size of Sawthoth Register
		m = ~sawthoth_tunes.size;
		// If Register is not Empty
		if(m>0)
		{
			// Select Old Frequency
			n = ~sawthoth_tunes[m.rand];
			// Callculate a selected Over-Tone for the Selected Frequency
			x = n * ( o + 1);
		}
		// If Register is Empty choose a new Random Frequency
		{ x = rrand(40, 10000); }
	};

	// Choosing of new conncted Overtone
	o = 6.bilinrand.abs;
	// Switch for Sawthoth or Square Mode
	if(v==True)
	{
		// Calculate new Frequency in Background of Square Synthesis
		y = x / ( 1 + ((o+1)*2));
	}
	{
		// Calculate new Frequency in Backgroun of Sawthoth Synthesis
		y = x / ( o + 1);
	};
	40.max(10000.min(y));
};
)

// Test for Calculation of new Frequency
//~calcTune.value(9);

// Routine for Playing the OverToneSelectOrgel
(
a = Routine.new({
	var x, xx, fx; // Memory for Temporary Variables
	// x is Size of Registers
	// xx is Selected Position in Register

	// Endless Loop for Playing the Orgel
	while{true}{
		// Estimate the Complet Size of booth Registers
		x = ~sawthoth_synths.size;
		x = x + ~square_synths.size;

		// Choose Synth Removing by Probabilty or max Number of nine Synths
		if(([false, false, true].choose).or(x>9))
		{
			// Estimate Size of Sawthoth Register
			x = ~sawthoth_synths.size;
			// Choose Synth Removing by Probability or max Number of six Synths
			if(( [false, true].choose).or(x>6))
			{
				// Is Register is Empty do nothing
				if(x==0)
				{
				}
				{
					//Select a Position in the Register
					xx = x.rand;
					// Free selected Synth
					~sawthoth_synths[xx].free;
					// Remove Entry in booth Registers
					~sawthoth_synths.removeAt(xx);
					~sawthoth_tunes.removeAt(xx);
				}
			};

			// Estimate Size of Square Register
			x = ~square_synths.size;
			// Choose Synth Removing by Probability or max Number of six Synths
			if(( [false, true].choose).or(x>6))
			{
				// Is Register is Empty do nothing
				if(x==0)
				{
				}
				{
					// Select a Position in the Register
					xx = x.rand;
					// Free Selected Synth
					~square_synths[xx].free;
					// Remove Entry in booth Registers
					~square_synths.removeAt(xx);
					~square_tunes.removeAt(xx);
				}
			};
		}
		{
		// Choose Probability of Type of new Synth Instance
		if([false, true].choose)
			{
			// For new Sawthoth Synth Instance
			// Estimate new Frequency in Sawthoth Mode
			fx = ~calcTune.value(False);
			fx.postln; // Controll Point
			// Call Function to create a new Sawthoth Instance
			~setSawthoth.value(fx);
			}
			{
			// For new Square Synth Instance
			// Estimate new Frequency in Square Mode
			fx = ~calcTune.value(True);
			fx.postln; // Controll point
			// Call Function to create a new Square Instance
			~setSquare.value(fx);
		}};
		// Wait a Random Time for new Period
		3.rand.wait;

		// Controll Point
		~square_synths.postln;
		~sawthoth_synths.postln;
		"Tre".postln;
	}

});
)


// Start OverToneSelectOrgel
a.play;