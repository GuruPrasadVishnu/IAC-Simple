# Adding Images to Markdown Files

## 📷 **Image Syntax Options**

### 1. **Basic Syntax**
```markdown
![Alt text](path/to/image.png)
![Alt text](path/to/image.png "Optional title")
```

### 2. **HTML Syntax (More Control)**
```markdown
<img src="path/to/image.png" alt="Alt text" width="600" height="400">
```

### 3. **Reference Style**
```markdown
![Alt text][image-reference]

[image-reference]: path/to/image.png "Optional title"
```

## 🎯 **For Your AWS Architecture Diagram**

### Option A: Local File (Recommended)
1. **Export from Draw.io**:
   - File → Export as → PNG (or SVG)
   - Save as `aws-architecture.png`

2. **Save in your repo**:
   ```
   InfrastructureAsCode/
   ├── docs/
   │   └── images/
   │       └── aws-architecture.png
   └── ARCHITECTURE.md
   ```

3. **Reference in Markdown**:
   ```markdown
   ![AWS Architecture](docs/images/aws-architecture.png)
   ```

### Option B: GitHub Raw URL
```markdown
![AWS Architecture](https://raw.githubusercontent.com/GuruPrasadVishnu/IAC-Simple/main/docs/images/aws-architecture.png)
```

### Option C: External Hosting
```markdown
![AWS Architecture](https://your-cdn.com/aws-architecture.png)
```

## 🔧 **Steps to Add Your Diagram**

### Step 1: Export from Draw.io
1. Open your diagram in Draw.io
2. **File → Export as → PNG**
3. Choose resolution (recommended: 300 DPI)
4. Download the file

### Step 2: Add to Repository
```bash
# Copy your exported image to:
cp ~/Downloads/aws-architecture.png docs/images/
```

### Step 3: Update ARCHITECTURE.md
```markdown
## Architecture Overview

![AWS EKS Microservices Architecture](docs/images/aws-architecture.png)

*Complete AWS EKS Microservices Platform with Kubernetes cluster representation*
```

### Step 4: Commit and Push
```bash
git add docs/images/aws-architecture.png
git add ARCHITECTURE.md
git commit -m "Add AWS architecture diagram"
git push
```

## 🎨 **Advanced Image Options**

### Centered Images
```markdown
<div align="center">
  <img src="docs/images/aws-architecture.png" alt="AWS Architecture" width="800">
</div>
```

### Multiple Images Side by Side
```markdown
| Before | After |
|--------|-------|
| ![Before](docs/images/before.png) | ![After](docs/images/after.png) |
```

### Image with Caption
```markdown
![AWS Architecture](docs/images/aws-architecture.png)
**Figure 1:** Complete AWS EKS Microservices Platform showing Kubernetes pods, services, and AWS integrations
```

## 📱 **Best Practices**

### File Formats
- **PNG**: Best for diagrams, screenshots
- **JPG**: Best for photos
- **SVG**: Best for scalable graphics
- **WebP**: Modern format, smaller files

### File Sizes
- Keep images under 1MB for fast loading
- Use compression tools if needed
- Consider different resolutions for mobile

### Naming Convention
```
docs/images/
├── aws-architecture.png
├── network-diagram.png
├── kubernetes-overview.png
└── traffic-flow.svg
```

### Alt Text
Always include descriptive alt text for accessibility:
```markdown
![AWS EKS cluster showing pods, services, ALB, and data services integration](docs/images/aws-architecture.png)
```

## 🚀 **GitHub-Specific Features**

### Relative Paths
```markdown
![Architecture](./docs/images/aws-architecture.png)
![Architecture](../images/aws-architecture.png)
![Architecture](docs/images/aws-architecture.png)
```

### GitHub Raw URLs
```markdown
![Architecture](https://raw.githubusercontent.com/username/repo/branch/path/image.png)
```

### GitHub Issues/Wiki
Images uploaded to GitHub issues can be referenced:
```markdown
![Architecture](https://user-images.githubusercontent.com/123456/image-id.png)
```

## 📝 **Example for Your Architecture Document**

```markdown
# Infrastructure Architecture Documentation

## Guru's EKS Microservices Platform

![AWS EKS Microservices Architecture](docs/images/aws-architecture.png)

*Figure 1: Complete AWS EKS Microservices Platform Architecture showing the interaction between AWS services, Kubernetes cluster, pods, services, and data layer components.*

### Key Components Visualization

The diagram above illustrates:

- **External Traffic Flow**: Users → IGW → ALB → Kubernetes Services → Pods
- **Kubernetes Layer**: Namespaces, pods, services, HPA, and node groups
- **AWS Services**: EKS, RDS, ElastiCache, MSK, Auto Scaling Groups
- **Network Segmentation**: Public/private subnets across multiple AZs
- **Auto-scaling Mechanisms**: HPA, VPA, and Cluster Autoscaler interactions

## Architecture Overview
...rest of your content...
```

Now you have everything you need to add your beautiful Draw.io diagram to the Markdown file! 🎉
