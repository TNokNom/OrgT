#!/usr/bin/env python3
# gnuradio_ofdm_tx.py
from gnuradio import gr, blocks, digital, uhd
import time

class OFDMTx(gr.top_block):
    def __init__(self, samp_rate=1e6, center_freq=2.4e9, tx_gain=30):
        gr.top_block.__init__(self)
        self.samp_rate = samp_rate
        self.center_freq = center_freq

        # Source: random bytes
        self.src = blocks.vector_source_b(list(range(256))*1000, repeat=True)

        # Packet encoder + OFDM mod
        self.packetizer = digital.packet_mod_b(digital.psk.psk_mod(2), payload_length_tag_key='packet_len')

        # NOTE: Many GNU Radio versions have different OFDM blocks. For real work use
        # digital.ofdm_mod or a GRC generated flowgraph.
        self.ofdm = digital.ofdm_mod(
            fft_len=64,
            cp_len=16,
            packet_length_tag_key='packet_len'
        )

        # USRP sink
        self.usrp_sink = uhd.usrp_sink(
            ",".join(("", "")),
            uhd.stream_args(cpu_format="fc32", channels=[0])
        )
        self.usrp_sink.set_samp_rate(self.samp_rate)
        self.usrp_sink.set_center_freq(self.center_freq)
        self.usrp_sink.set_gain(tx_gain)

        # Connections (placeholder - adapt to your OFDM blocks)
        self.connect(self.src, self.ofdm, self.usrp_sink)

if __name__ == '__main__':
    tb = OFDMTx()
    tb.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        tb.stop()
        tb.wait()
