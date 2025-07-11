const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

// Initialize Prisma Client
const prisma = new PrismaClient();

async function main() {
  console.log('Starting database seeding...');

  // Create root superUser
  const hashedPassword = await bcrypt.hash('adminPassword123', 10);
  
  const rootUser = await prisma.superUser.create({
    data: {
      email: 'admin@example.com',
      password: hashedPassword,
      // Note: createdById and updatedById are null for root user
    }
  });
  
  console.log('Root superUser created:', rootUser.id);

  // Create Telegram communication channel
  const telegramChannel = await prisma.communicationChannel.create({
    data: {
      name: 'Telegram',
      createdById: rootUser.id,
      updatedById: rootUser.id,
    }
  });
  
  console.log('Telegram communication channel created:', telegramChannel.id);
  
  // Create WhatsApp communication channel
  const whatsappChannel = await prisma.communicationChannel.create({
    data: {
      name: 'WhatsApp',
      createdById: rootUser.id,
      updatedById: rootUser.id,
    }
  });
  
  console.log('WhatsApp communication channel created:', whatsappChannel.id);

  // Create types of messages available on Telegram
  const telegramMessageTypes = [
    {
      name: 'Text',
      description: 'Simple text message',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'text', 
        format: 'plain',
        characterLimit: 4096
      },
    },
    {
      name: 'Photo',
      description: 'Image message',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'photo',
        supportedFormats: ['JPEG', 'PNG', 'GIF'],
        maxFileSize: 10485760 // 10MB in bytes
      },
    },
    {
      name: 'Voice',
      description: 'Voice note message',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'voice',
        supportedFormats: ['OGG', 'MP3', 'M4A'],
        maxDuration: 60 // in seconds
      },
    },
    {
      name: 'Video',
      description: 'Video message',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'video',
        supportedFormats: ['MP4', 'MOV'],
        maxFileSize: 52428800 // 50MB in bytes
      },
    },
    {
      name: 'Document',
      description: 'Document/file message',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'document',
        supportedFormats: ['PDF', 'ZIP', 'DOC', 'DOCX', 'XLS', 'XLSX'],
        maxFileSize: 52428800 // 50MB in bytes
      },
    },
    {
      name: 'Poll',
      description: 'Poll message',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'poll',
        maxOptions: 10,
        optionCharacterLimit: 100
      },
    },
    {
      name: 'Sticker',
      description: 'Sticker message',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'sticker',
        formats: ['WebP', 'TGS'],
        animated: true
      },
    },
    {
      name: 'Location',
      description: 'Location data',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'location',
        format: { latitude: 'float', longitude: 'float' }
      },
    },
    {
      name: 'Contact',
      description: 'Contact information',
      recivedFromChannel: true,
      responseStructure: { 
        type: 'contact',
        fields: ['name', 'phone', 'email']
      },
    },
    {
      name: 'InlineKeyboard',
      description: 'Interactive buttons message',
      recivedFromChannel: false,
      responseStructure: { 
        type: 'inlineKeyboard',
        maxButtons: 100,
        maxButtonsPerRow: 8
      },
    },
    {
      name: 'ReplyKeyboard',
      description: 'Custom keyboard message',
      recivedFromChannel: false,
      responseStructure: { 
        type: 'replyKeyboard',
        maxButtons: 100,
        maxButtonsPerRow: 8,
        oneTime: 'boolean',
        resize: 'boolean'
      },
    }
  ];

  for (const messageType of telegramMessageTypes) {
    await prisma.typeOfMessage.create({
      data: {
        name: messageType.name,
        description: messageType.description,
        recivedFromChannel: messageType.recivedFromChannel,
        responseStructure: messageType.responseStructure,
        createdById: rootUser.id,
        updatedById: rootUser.id,
      }
    });
  }

  console.log('Telegram message types created');

  
}

main()
  .catch((e) => {
    console.error('Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    // Close Prisma client connection
    await prisma.$disconnect();
  });