//
//  Synth.swift
//  Useless_Synth
//
//  Created by Alex Nascimento on 15/04/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//
import AVFoundation

let TWO_PI = Float.pi * 2

class Synth {
    
    let engine = AVAudioEngine()
    let outputFormat: AVAudioFormat
    let inputFormat: AVAudioFormat?
    let sampleRate: Float
    
    var frequency: Float = 432 // la 432Hz
    var amplitude: Float = 1
    var phase: Float = 0
    var phaseIncrement: Float
    
    var oscillator: AVAudioSourceNode!
    
    init() {
        self.outputFormat = self.engine.outputNode.outputFormat(forBus: 0)
        self.inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                    sampleRate: outputFormat.sampleRate,
                                    channels: 1,
                                    interleaved: outputFormat.isInterleaved)
        self.sampleRate = Float(outputFormat.sampleRate)
        self.phaseIncrement = (TWO_PI / sampleRate) * frequency
        
        setupOscillator()
        setupEngine()
        startEngine()
    }
    
    func setupOscillator() {
        self.oscillator = AVAudioSourceNode { (_, _, frameCount, bufferPointer) -> OSStatus in
            
            let audioBufferList = UnsafeMutableAudioBufferListPointer(bufferPointer)
            
            // para cada frame do packet
            for frame in 0..<Int(frameCount) {
                let value = sin(self.phase) * self.amplitude // senoide por enquanto
                
                self.phase += self.phaseIncrement
                // TODO: fazer sempre ficar entre 0 2 2pi
                
                // para cada canal do frame (no caso é só 1 mesmo)
                for buffer in audioBufferList {
                    let samples: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    samples[frame] = value
                }
            }
            return noErr
        }
    }
    
    func setupEngine() {
        self.engine.attach(oscillator)
        self.engine.connect(oscillator, to: engine.mainMixerNode, format: inputFormat)
        self.engine.connect(engine.mainMixerNode, to: engine.outputNode, format: outputFormat)
        self.engine.mainMixerNode.outputVolume = 0.5
    }
    
    func startEngine() {
        do {
            try self.engine.start()
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (_) in
                self.engine.stop()
            }
        } catch {
            print("Unable to start engine due to error: \(error)")
        }
    }
}
