#!/usr/bin/env python

from gnuradio import gr
from gnuradio import audio, analog, blocks, filter, digital
from gnuradio import wxgui
from gnuradio.wxgui import stdgui2, fftsink2, scopesink2
import wx
import numpy
import sys

class detect_opener_bits(gr.sync_block):
    def __init__(self):
        gr.sync_block.__init__(
                self,
                name = "detect_opener_bits",
                in_sig = [numpy.byte],
                out_sig = None
        )
        self.risen = False
        self.count = 0
        self.code = ""
        self.timestamp = 0
        self.lastsymbol = 0
    
    def work(self, input_items, output_items):
        in0 = input_items[0]
        self.timestamp = self.timestamp + 1
        for val in in0:
            if val and not self.risen:
                # new symbol
                self.risen = True
                self.count = 1
            elif val and self.risen:
                #continuation of symbol
                self.count = self.count + 1
            elif not val:
                #check to see if symbol
                if self.risen:
                    if self.count > 27:
                        if (self.timestamp - self.lastsymbol) > 82:
                            # treat as new code
                            self.code = ""
                        self.code = self.code + '1'
                        self.lastsymbol = self.timestamp
                    elif self.count > 8:
                        if (self.timestamp - self.lastsymbol) > 82:
                            # treat as new code
                            self.code = ""
                        self.code = self.code + '0'
                        self.lastsymbol = self.timestamp
                    if len(self.code) == 10:
                        print self.code
                        self.code = ""
                    self.risen = False
                    self.count = 0
                
        return len(input_items[0])

class my_gui_flow_graph(stdgui2.std_top_block):
    def __init__(self, frame, panel, vbox, argv):
        stdgui2.std_top_block.__init__(self, frame, panel, vbox, argv)

        sample_rate = 2e6
        center_freq = 300e6
        filename = '/home/sdr/Desktop/Lab/Labs/Multicode/multi_code_300MHz_2Mss.raw'

        fsrc = blocks.file_source(gr.sizeof_gr_complex, filename, True)
        throt = blocks.throttle(gr.sizeof_gr_complex, sample_rate)
        c_to_m = blocks.complex_to_mag()
        #scope = scopesink2.scope_sink_f(panel, sample_rate=sample_rate, size=(1200,800))
        rat = filter.fir_filter_ccc(100, filter.firdes.low_pass_2(1, sample_rate, 1000000, 500000, 100))
        detector = detect_opener_bits()
        squelch = analog.pwr_squelch_cc(-60,1,0,False)
        slicer = digital.binary_slicer_fb() 
        add = blocks.add_const_vff((-.003, ))
        self.connect(fsrc, throt)
        self.connect(throt, rat)
        self.connect(rat, c_to_m)
        self.connect(c_to_m, add)
        self.connect(add, slicer)
        #self.connect(c_to_m, scope)
        self.connect(slicer, detector)

        #vbox.Add(scope.win, 1, wx.EXPAND)


if __name__ == '__main__':
    try:
        app = stdgui2.stdapp(my_gui_flow_graph, "garage")
        app.MainLoop()
    except [[KeyboardInterrupt]]:
        pass
