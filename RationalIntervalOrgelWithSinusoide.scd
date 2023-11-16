
// Declaration of Synths
// Declsration of Sinusidal Synth
(
SynthDef(\Sinus, { |out, freq|
    Out.ar(out,
		SinOsc.ar(freq, 0.2);
    )
}).add;
)

// Declaration for Memory Registers
(
// Sinusidal Synth Registers
// Declaration of Memory for Tunes / Frequencies
~sinus_tunes = Array.new();
// Declaration of Memory for Synth Instances
~sinus_synths = Array.new();
)

/**
// Ckeck Content of Synth Registers
~sinus_tunes;
~sinus_synths;
**/

// Function to create a Sinusidal Synth Instance
(
~setSinus = { arg freq; // Input for choosen Frequency
	// Call Square Synth
	x = Synth(\Sinus, [out: 0, freq: freq ]);
	// Save Frequencie in to Register
	~sinus_tunes = ~sinus_tunes.add(freq);
	// Save Synth Instance to Register
	~sinus_synths = ~sinus_synths.add(x);
};
)

// Function to Calculate new Frequency from Given aktiv Sound-Set
(
~calcTune = {
	arg v; // Paramter for Type of Calculation
	// True is Square False is Sawthoth Mode
	var n, x, y, o, oo, m; // Memory Declarations for Temorary Variables
	// n is old Frequency
	// oo is Factor for Division
	// o is Factor of Division
	// x is Rational Intervall Quotient
	// y is new Frequency

	// Choose Register for select old Frequency
	// Test is Register Empty then Choose Default Frequency
	if(~sinus_tunes.size < 1)
	{
		n = 440; // Default Frequency
	}
	{
			// Is Register is not Empty choose a Random Entry
		m = ~sinus_tunes.size.rand;
		m.postln;
		n = ~sinus_tunes[m];
	};


	// Calculate Factor of Division
	o = 6.bilinrand.abs;
	// Calculate Factor for Division
	oo = o.bilinrand.abs;
	// Build Qutient
	x = (oo.asFloat+1)/(o+1);

	// Choose Direction of Manipulation
	if( [false, true].choose)
	{
		// First Direction
		y = x * n;
		"Heigh".postln;
		x.postln;
	}
	{
		// Second Direction
		// Make Qutient Properly for Secod Direction
		if(x==0){x = 1;};
		y = n / x;
		"Low".postln;
	};

	40.max(10000.min(y));
};
)

/* Test for Calculation of new Frequency
~sinus_tune = [1,3,4]
~calcTune.value(9);
*/

// Routine for Playing the OverToneSelectOrgel
(
a = Routine.new({
	var x, xx, fx; // Memory for Temporary Variables
	// x is Size of Registers
	// xx is Selected Position in Register

	// Endless Loop for Playing the Orgel
	while{true}{
		// Estimate the Complet Size of Registers
		x = ~sinus_synths.size;
		// Choose Synth Removing by Probabilty or max Number of nine Synths
		if(([false, false, true].choose).or(x>9))
		{
			// Estimate Size of Sinusidal Register
			x = ~sinus_synths.size;
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
					~sinus_synths[xx].free;
					// Remove Entry in booth Registers
					~sinus_synths.removeAt(xx);
					~sinus_tunes.removeAt(xx);
				}
			};

		}
		{
		// Choose Probability of Type of new Synth Instance
		if([false, true].choose)
			{
			// For new Sinusidal Synth Instance
			// Estimate new Frequency in Sinusidal Mode
			fx = ~calcTune.value(False);
			fx.postln; // Controll Point
			// Call Function to create a new Sinusidal Instance
			~setSinus.value(fx);
			}
		};
		// Wait a Random Time for new Period
		3.rand.wait;

		// Controll Point
		~sinus_synths.postln;
		"Tre".postln;
	}

});
)


// Start OverToneSelectOrgel
a.play;

6.bilinrand.abs.bilinrand;