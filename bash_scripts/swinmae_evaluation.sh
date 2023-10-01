#!/bin/bash

source $HOME/miniconda3/bin/activate
conda activate plr
module load eth_proxy cuda/11.3.1 gcc/8.2.0 ninja



args=(
    --batch_size 8
    --epochs 1000
    --num_workers 2
    --lr 5e-4
    --weight_decay 0.01
    --warmup_epochs 60 
    --optimizer adamw
    --eval
    # Model parameters
    # --curriculum_learning
    --model_select swin_mae
    # --model swin_mae_patch2_base_line_ws4
    --model swin_mae_deepencoder_patch2_base_line_ws4
    --grid_reshape
    --circular_padding
    --conv_projection
    --log_transform 
    --pixel_shuffle_expanding
    # --eval
    # Dataset
    --dataset_select durlar
    --data_path /cluster/work/riner/users/biyang/dataset/depth_intensity_new/
    # --log_transform
    --save_pcd
    # --crop
    --loss_on_unmasked
    # WandB Parameters
    --run_name eval_800epochs:durlar_pretrain_128x2048_linepatch1x4_deepencoder_mr025
    --entity biyang
    --project_name swin_mae_lowres_durlar
    # --wandb_disabled
    --output_dir ./experiment/durlar/LowRes/mr025_128_2048_linepatch1x4_deepencoder/
    --mask_ratio 0.25
    # For swim_mae, we have to give the image size that could be split in to 4 windows and then 16x16 patchs
    --img_size 128 2048
    --input_size 128
    --in_chans 1

    
    # --img_size 224 224
    # --input_size 224
    # --window_size 7
    # --patch_size 4 4
    # --in_chans 3
    )

# python mae/main_ouster.py "${args[@]}"   
#python -m torch.distributed.launch --nproc_per_node=2 mae/main_ouster.py "${args[@]}"
torchrun --nproc_per_node=1 mae/main_ouster.py "${args[@]}"