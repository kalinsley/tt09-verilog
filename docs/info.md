<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This model uses a **spiking neural network (SNN)** to classify MNIST digits. The network consists of three layers of **leaky integrate-and-fire (LIF)** neurons:

1. **Input layer (8 neurons)**: Originally, each neuron in the input layer receives one bit of an 8-bit representation of an MNIST image pixel (0-255 grayscale). Each pixel value was then converted into spikes. Due to design constraints, the 8 bit input (ui_in) serves as the 8 'neuron' input layer, werhe each bit of the incoming pixel value represented a spike (1) or no spike (0). 
  
2. **Hidden layer (3 neurons)**: This layer performs the computations based on the spikes received from the input layer. In this  implementation, the neurons in the hidden layer do not undergo training but enable the network to generate spike patterns that can be interpreted by the output layer.
  
3. **Output layer (10 neurons)**: This layer consists of 10 neurons corresponding to the 10 possible MNIST digit classes (0-9). The neuron that fires the most determines the predicted class. Ideally, the 8 bit ouput (uo_out) would take on the class with the highest spiking frequency. Due to another overstimation in design scale, the oupout ties to the first 

Unlike traditional machine learning models, this SNN does not require training. The classification is based purely on the temporal and spatial patterns of spikes that emerge from the input data, making the network more closely resemble biological neural networks.


## How to test

1. **Prepare the MNIST test dataset**: Because this is a simulated SNN with randomized weights, test model on 784 (28x28) random 8 bit input values (0-255), where each bit corresponds to one of the input neurons (8 total). The grayscale value of the pixel will determine how many spikes each neuron generates.
  
2. **Run the simulation**: Run the random MNIST input through the simulated spiking neural network in your Verilog environment. The input neurons will send spikes based on the pixel values of the test image.

3. **Monitor the output spikes**: Observe the output layer's spike activity. Each output neuron corresponds to one of the possible classes (0-9). The neuron that generates the most spikes during the test run is the predicted class.

4. **Evaluate performance**: In a case this was a trained model, evaluate the performance of the model by comparing the predicted class with the true class of the MNIST image.

This model uses the timing of spikes (not the amplitude or traditional learning methods) to classify the digits, making it a simple but effective demonstration of an untrained spiking neural networks.

## External hardware

No external hardware is required for this project. The model is entirely simulated in Verilog, and all operations (input processing, spike generation, and classification) occur within the simulation environment. Therefore, you can run and test the model using any FPGA or simulation software that supports Verilog, without the need for additional hardware components. LEDS or some other sort of visualizer may be used to observe the output. 
