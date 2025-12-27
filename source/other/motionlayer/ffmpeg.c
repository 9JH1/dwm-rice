//comp gcc -o out slice_frame.c -lavcodec -lavformat -lavutil -lswscale
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>
#include <stdio.h>
#include "motionlayer.h"

void save_frame_as_png(AVFrame *frame, int width, int height, const char *filename) {
    // Change to const AVCodec *
    const AVCodec *codec = avcodec_find_encoder(AV_CODEC_ID_PNG);
    if (!codec) {
        fprintf(stderr, "PNG codec not found\n");
        return;
    }

    AVCodecContext *codec_ctx = avcodec_alloc_context3(codec);
    if (!codec_ctx) {
        fprintf(stderr, "Could not allocate codec context\n");
        return;
    }

    codec_ctx->width = width;
    codec_ctx->height = height;
    codec_ctx->pix_fmt = AV_PIX_FMT_RGBA;
    codec_ctx->time_base = (AVRational){1, 25};

    if (avcodec_open2(codec_ctx, codec, NULL) < 0) {
        fprintf(stderr, "Could not open codec\n");
        avcodec_free_context(&codec_ctx);
        return;
    }

    // ... (rest of the function remains unchanged)
    // Convert frame to RGBA
    struct SwsContext *sws_ctx = sws_getContext(width, height, frame->format,
                                                width, height, AV_PIX_FMT_RGBA,
                                                SWS_BILINEAR, NULL, NULL, NULL);
    AVFrame *rgba_frame = av_frame_alloc();
    if (!rgba_frame) {
        fprintf(stderr, "Could not allocate RGBA frame\n");
        sws_freeContext(sws_ctx);
        avcodec_free_context(&codec_ctx);
        return;
    }

    rgba_frame->width = width;
    rgba_frame->height = height;
    rgba_frame->format = AV_PIX_FMT_RGBA;
    if (av_frame_get_buffer(rgba_frame, 0) < 0) {
        fprintf(stderr, "Could not allocate RGBA frame buffer\n");
        av_frame_free(&rgba_frame);
        sws_freeContext(sws_ctx);
        avcodec_free_context(&codec_ctx);
        return;
    }

    sws_scale(sws_ctx, (const uint8_t * const *)frame->data, frame->linesize, 0, height,
              rgba_frame->data, rgba_frame->linesize);

    // Encode to PNG
    AVPacket *pkt = av_packet_alloc();
    if (!pkt) {
        fprintf(stderr, "Could not allocate packet\n");
        av_frame_free(&rgba_frame);
        sws_freeContext(sws_ctx);
        avcodec_free_context(&codec_ctx);
        return;
    }

    if (avcodec_send_frame(codec_ctx, rgba_frame) < 0 ||
        avcodec_receive_packet(codec_ctx, pkt) < 0) {
        fprintf(stderr, "Error encoding frame\n");
    } else {
        FILE *file = fopen(filename, "wb");
        if (file) {
            fwrite(pkt->data, 1, pkt->size, file);
            fclose(file);
        } else {
            fprintf(stderr, "Could not open %s\n", filename);
        }
    }

    av_packet_free(&pkt);
    av_frame_free(&rgba_frame);
    sws_freeContext(sws_ctx);
    avcodec_free_context(&codec_ctx);
}



int get_first_frame(char *video, char *output_path) {

    const char *input_file = video;
    char *output_file = output_path;

    // Initialize FFmpeg
    avformat_network_init();

    // Open video file
    AVFormatContext *fmt_ctx = NULL;
    if (avformat_open_input(&fmt_ctx, input_file, NULL, NULL) < 0) {
        fprintf(stderr, "Could not open input file %s\n", input_file);
				return 1;
    }

    if (avformat_find_stream_info(fmt_ctx, NULL) < 0) {
        fprintf(stderr, "Could not find stream information\n");
        avformat_close_input(&fmt_ctx);
				return 1;
    }

    // Find video stream
    int video_stream = -1;
    for (unsigned int i = 0; i < fmt_ctx->nb_streams; i++) {
        if (fmt_ctx->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            video_stream = i;
            break;
        }
    }

    if (video_stream == -1) {
        fprintf(stderr, "No video stream found\n");
        avformat_close_input(&fmt_ctx);
				return 1;
    }

    // Get decoder
    const AVCodec *codec = avcodec_find_decoder(fmt_ctx->streams[video_stream]->codecpar->codec_id);
    if (!codec) {
        fprintf(stderr, "Decoder not found\n");
        avformat_close_input(&fmt_ctx);
				return 1;
    }

    AVCodecContext *codec_ctx = avcodec_alloc_context3(codec);
    if (!codec_ctx) {
        fprintf(stderr, "Could not allocate codec context\n");
				free(output_file);
        avformat_close_input(&fmt_ctx);
				return 1;
    }

    if (avcodec_parameters_to_context(codec_ctx, fmt_ctx->streams[video_stream]->codecpar) < 0) {
        fprintf(stderr, "Could not copy codec parameters\n");
        avcodec_free_context(&codec_ctx);
        avformat_close_input(&fmt_ctx);
				return 1;
    }

    if (avcodec_open2(codec_ctx, codec, NULL) < 0) {
        fprintf(stderr, "Could not open codec\n");
        avcodec_free_context(&codec_ctx);
        avformat_close_input(&fmt_ctx);
				return 1;
    }

    // Read first frame
    AVPacket *packet = av_packet_alloc();
    AVFrame *frame = av_frame_alloc();
    if (!packet || !frame) {
        fprintf(stderr, "Could not allocate packet or frame\n");
        av_packet_free(&packet);
        av_frame_free(&frame);
        avcodec_free_context(&codec_ctx);
        avformat_close_input(&fmt_ctx);
				return 1;
    }

    while (av_read_frame(fmt_ctx, packet) >= 0) {
        if (packet->stream_index == video_stream) {
            if (avcodec_send_packet(codec_ctx, packet) >= 0 &&
                avcodec_receive_frame(codec_ctx, frame) >= 0) {
                save_frame_as_png(frame, codec_ctx->width, codec_ctx->height, output_file);
                break; // Got the first frame, exit
            }
        }
        av_packet_unref(packet);
    }

    // Cleanup
    av_packet_free(&packet);
    av_frame_free(&frame);
    avcodec_free_context(&codec_ctx);
    avformat_close_input(&fmt_ctx);
    return 0;
}
