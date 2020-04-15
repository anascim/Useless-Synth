//
//  Synth.swift
//  Useless_Synth
//
//  Created by Alex Nascimento on 15/04/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//
import AVFoundation

class Synth {
    
    
    init() {
        
        
        var engine = AVAudioEngine()
        
        var outputFormat = engine.outputNode.outputFormat(forBus: 0)
        var inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                        sampleRate: outputFormat.sampleRate,
                                        channels: 1,
                                        interleaved: outputFormat.isInterleaved)
        
        var frequency: Float = 432 // la 432Hz
        var amplitude: Float = 1
        var sampleRate: Float = Float(outputFormat.sampleRate)
        var phase: Float = 0
        let phaseIncrement: Float = (Float.pi * 2 / Float(outputFormat.sampleRate)) * frequency
        var oscillator = AVAudioSourceNode { (_, _, frameCount, bufferPointer) -> OSStatus in
            
            let audioBufferList = UnsafeMutableAudioBufferListPointer(bufferPointer)
            
            // para cada frame do packet
            for frame in 0..<Int(frameCount) {
                var value = sin(phase) * amplitude // senoide por enquanto
                
                phase += phaseIncrement
                // TODO: fazer sempre ficar entre 0 2 2pi
                
                // para cada canal do frame (no caso é só 1 mesmo)
                for buffer in audioBufferList {
                    let samples: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    samples[frame] = value
                }
            }
            return noErr
        }
        
        engine.attach(oscillator)
        engine.connect(oscillator, to: engine.mainMixerNode, format: inputFormat)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: outputFormat)
        engine.mainMixerNode.outputVolume = 0.5
        
        do {
            try engine.start()
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (_) in
                engine.stop()
            }
        } catch {
            print("Unable to start engine due to error: \(error)")
        }
    }
}
