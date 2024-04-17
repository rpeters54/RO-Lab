Riley Peters, Avery Taylor, Junior Perez

Dr. Beard

CPE 426

10/24/23

Lab 1 - Configurable Ring-Oscillator PUF

**<u>1. Questions:</u>**

**Initial Questions:**

1.  What did you change about the provided configurable ring-oscillator?

We modified the ring-oscillator by removing its final slice, reducing
the total number of Select and Bx bits to 6 instead of 8.

2.  How many ROs are necessary?

Since 8 frequency comparisons are needed to construct the response, the
PUF requires 9 ROs.

3.  Why will a 50 MHz clock work for this design?

Since the ROs are counting at a significantly higher frequency than the
system clock, a 50 MHz clock will mean that the ROs have enough time to
count. If the system clock was too fast, the ROs would not have enough
time to count, perhaps not even being able to count at all. So the
system clock has to be slower than the RO clock.

4.  Would any arbitrary clock speed work for this design?

No, as mentioned previously, the system clock must be slower than the RO
clock to be able to allow the ROs enough time to count.

5.  What did you decide to use for the max value of std_counter?

The max value chosen for std_counter was 32'h0000FFFF, which is long
enough to allow the ROs to do a large count.

6.  How does this value impact the PUF?

The value determines how long each RO counts. Increasing the value
improves the measurement resolution. However, longer measurement times,
increase the total time to compute the challenge-response pair.

7.  Why would we want to know if the challenge response is complete?

Two reasons: the challenge-response must be complete to compute the
encryption key, and we want the seven-segment display to show only valid
data. A challenge-response complete signal allows us to signal to both
the encryption and seven-seg modules when the computation is done, so
they can react appropriately.

8.  Why might we want to hash the challenge concatenated with the
    response?

You make it more difficult for an attacker to guess what the response is
to a given input.

9.  Are the challenge-response pairs the same for each location?

No, challenge-response pairs are unique based on how the
ring-oscillators have been placed around the board.

10. Should they be (include details)?

They should not. At different locations on the board, the concentration
of dopant should vary enough that the RO frequency is unique. Therefore,
if any RO is moved, it should affect the output.

11. What are the interboard hamming distances:

> pblock board locations (X1Y1, X0Y0, X1Y0)

1.  Challenge: 000000

> <img src="media/image6.png" style="width:5.40625in;height:1.52083in" />

2.  Challenge: 110010

> <img src="media/image14.png" style="width:5.42708in;height:1.42708in" />

3.  Challenge: 010101

> <img src="media/image1.png" style="width:5.4375in;height:1.48958in" />

4.  Challenge: 111111

> <img src="media/image2.png" style="width:5.38542in;height:1.54167in" />

5.  Challenge: 100001

> <img src="media/image10.png" style="width:5.52083in;height:1.41667in" />

12. What are the intra-board and inter-board hamming distances?

> pblock board locations (X1Y0)

1.  Challenge: 000000

> <img src="media/image15.png" style="width:5.26042in;height:1.41667in" />

2.  Challenge: 110010

<img src="media/image5.png" style="width:5.34375in;height:1.375in" />

3.  Challenge: 010101

> <img src="media/image13.png" style="width:5.27083in;height:1.36458in" />

4.  Challenge: 111111

<img src="media/image7.png" style="width:5.29167in;height:1.38542in" />

5.  Challenge: 100001

> <img src="media/image9.png" style="width:5.29167in;height:1.39583in" />

13. What are ideal?

The best possible hamming distance is the total number of bits divided
by 2. This defines a challenge-response where the challenge is different
from the response by 50%. If it's any more or less, bits in the response
have a higher correlation to bits in the challenge, making the response
easier for an attacker to predict.

14. Discuss anything of note about your particular implementation or
    results.

Some of the hamming distances were too high (above 4). And some of the
hamming distances were 0 which is really bad. Based on our hamming
distances an attacker could correlate inputs with outputs. Also, the
inter-hamming distances were higher than the intra-hamming distances due
to our board layout.

**Final Questions:**

1.  How difficult would it be to expand the number of challenge bits and
    the bits of the response? Describe the process and any
    considerations needed to ensure the PUF functions correctly.

Increasing the challenge width would require that we increase the size
of our Ring Oscillator, or just add those bits to the encryption. If we
chose to increase the RO size, it would make our design significantly
larger and more complex as we would have to increase the number of
muxes. Furthermore, RO frequency would decrease, which may cause
problems when sampling using a 50MHz clock. If we instead avoided
altering the RO and just passed the bits into the encryption, the
implementation would be a much simpler process. However, the PUF
response would only be determined by a small portion of the challenge,
reducing its strength. On the other hand, adding response bits is
relatively simple. Since the number of Ring Oscillators in our PUF is
equal to the response width plus 1, we would only need to add one RO per
bit. Even so, adding more ROs would increase the time to compute
comparisons.

2.  How might variations in temperature and voltage of the chip affect
    PUF? Think of both raw entropy and the result of the hash. What are
    some methods which could mitigate the effect?

Temperature and voltage variations could affect the frequency of each
RO. With significant enough variations in either, this could cause
challenge-response pairs to differ from their expected value. By keeping
the PUF at a consistent temp with a heat-sync, shielding its inputs from
voltage spikes, and shielding the device as a whole from emf, these
hazards can be reduced.

3.  You might have noticed in the paper and in our implementation the
    hamming distance between adjacent challenges is fairly minimal (15%
    in Xin et. Al). What might cause this? Can you think of a way of
    changing how we use the counter output to increase the hamming
    distance? Hint: This might mean reducing the number of usable
    response bits in the counter.

The hamming distances between adjacent challenges is fairly minimal
because all of the ROs will still share a very similar configuration.
For example, if Bx\[0\] is set high, all RO’s will have their first mux
set to the latched input. Assuming that these latches all add a
relatively similar amount of delay, setting Bx\[0\] high will only have
a minor affect on the output. To reduce the similarity, we could XOR
adjacent comparison outputs. This would increase the hamming distance
between challenges, but would half the number of response bits given the
same number of ROs.

4.  How could this implementation be modified on a board so that it
    could be verified from an external source and ensure freshness?
    (Don’t think about the BASYS 3 board, instead consider the
    fundamental structure of the device, including generic inputs and
    outputs)

Use the GPIO ports to receive challenges and send responses to verify
that it works. In our setup we were unable to verify that the puff works
correctly through a traditional simulation due to the oscillating nature
of the PUFF. If GPIO was used we could verify it using an external
source such as a logic analyzer.

**<u>2. Approach and Hardships:</u>**

**Approach:**

To construct the PUF system, our work was separated into a series of
steps:

1.  Designed a Ring-Oscillator module, which when enabled produced a
    output signal with a unique frequency based upon its placement in
    the FPGA

2.  Constructed a simple top level module, passing the output of one
    Ring-Oscillator into a counter, and blinking an LED each time the
    counter overflowed

3.  Implemented the challenge-response system using a finite state
    machine consisting of these steps

- Standby: Wait for the next challenge

- Clear: Clears the current Ring-Oscillator count

- Select: Selects the next Ring-Oscillator to measure

- Count: Given the selected

- Ring-Oscilllator, measure the amount of oscillations in a finite time
  period

- Store: Store the current Ring-Oscillator count in its corresponding
  register. If there are more ROs to measure, return to clear.
  Otherwise, move to Respond.

- Respond: Calculate each bit of the response by comparing the measured
  Ring-Oscillator counts. Then, display the response and return to
  Standby.

4.  Added a 128 RSA encryption module that computes the encryption key
    after receiving the challenge and response as its input.

5.  Added a Seven Segment Display module and logic that displays either
    a portion of the encryption key or challenge-response pair on the
    seven segment display based on the values of a set of input
    switches.

**Hardships:**

Along the way, we encountered a variety of complications, some a result
of Vivado, others relating to improper understanding of the design.

1\. The first and most significant problem encountered while
constructing the PUF was handling Vivado. Since constructing
combinational loops is generally considered bad practice, Vivado’s
optimizations would destroy the oscillator. To avoid this, we had to
include an excessive amount of “dont_touch” directives, so that the
optimizer would not modify it. Furthermore, to generate the bitstream
for our final PUF, each ring oscillator required a constraint directive
to specify that a combinational loop was allowed. This battle with the
software took altogether more time than both designing and implementing
every other portion of the PUF.

2\. Another problem we encountered was figuring out a way to debug the
PUF. We had to get creative to simulate the ROs in order to use the
simulation window to verify that the FSM and the rest of the modules
were working.

3\. Lastly, the design process of the PUF was a challenge. We originally
tried to do a design similar to what was described in the paper, where
we would record the outputs of two ROs then compare them to find a
single bit of the response output. However, our code got quite messy,
and we were not properly recording these outputs. We decided to utilize
a simpler design where we would find the outputs of all 9 ROs, one at a
time, and then do the comparisons all at once. This resulted in
significantly simple logic that allowed us to get the PUF to work.

**<u>3. Challenge Response Function:</u>**

**Encrypted PUF RTL:**

<img src="media/image8.png" style="width:6.46222in;height:2.76068in" />

<img src="media/image8.png" style="width:6.30335in;height:3.46507in" />

**<u>4. Behavior Analysis:</u>**

**Original Configuration:**

**Implemented Design:**

<img src="media/image4.png" style="width:3.75698in;height:5.98738in" />

**Hamming Data:**

| Challenge | Response | Hamming Distance |
|-----------|----------|------------------|
| 0x00      | 0xAB     | 5                |
| 0xA8      | 0xBA     | 2                |
| 0xA1      | 0xEB     | 3                |
| 0x1C      | 0xB3     | 6                |
| 0x0F      | 0xF7     | 5                |

**Average Hamming Distance: 4.2**

**First Config:**

**Implemented Design:**

<img src="media/image11.png" style="width:3.79988in;height:5.83105in" />

**Hamming Data:**

| Challenge | Response | Hamming Distance |
|-----------|----------|------------------|
| 0x00      | 0x87     | 4                |
| 0xA8      | 0xB7     | 5                |
| 0xA1      | 0x87     | 3                |
| 0x1C      | 0xA4     | 4                |
| 0x0F      | 0xB6     | 5                |

**Average Hamming Distance: 4.2**

**Second Configuration:**

**Implemented Design:**

<img src="media/image3.png" style="width:3.95196in;height:6.24479in" />

**Hamming Data:**

| Challenge | Response | Hamming Distance |
|-----------|----------|------------------|
| 0x00      | 0x4A     | 3                |
| 0xA8      | 0x2E     | 3                |
| 0xA1      | 0x4E     | 7                |
| 0x1C      | 0x66     | 5                |
| 0x0F      | 0x76     | 5                |

**Average Hamming Distance: 4.6**

**Third Configuration:**

**Implemented Design:**

<img src="media/image12.png" style="width:3.89648in;height:6.23437in" />

**Hamming Data:**

| Challenge | Response | Hamming Distance |
|-----------|----------|------------------|
| 0x00      | 0x96     | 4                |
| 0xA8      | 0x12     | 5                |
| 0xA1      | 0x97     | 4                |
| 0x1C      | 0x92     | 4                |
| 0x0F      | 0x9A     | 4                |

**Average Hamming Distance: 4.2**
