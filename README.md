# terrapack

Terraform + packer modules & recipes

## Usage

1. Choose appropriate terraform recipe in `recipes` folder.
2. Find required packer template for the receipe at `images` folder.
3. Compose your packer variable file.
4. Bake image(s) by `packer` with the variable file.
5. Compose your terraform recipe variable file with baked image id(s).
6. Deploy your recipe into a provider with the variable file.

